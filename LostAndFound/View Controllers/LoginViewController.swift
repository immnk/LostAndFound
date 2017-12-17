//
//  ViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var choiceControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicatorView: NVActivityIndicatorView!
    var amIReadingFromStore: Bool = false
    
    struct AlertSet {
        let buttonTitle: String,
        completionHandler: (UIAlertAction) -> ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = NVActivityIndicatorView(frame: self.accessibilityFrame)
        
        // Handle the text field’s user input through delegate callbacks.
        passwordTextField.delegate = self
        
        if let creds = self.loadCreds() {
            self.showSpinner(message: "Authenticating...", timeout: 3000)
            self.signInUser(email: creds.username, password: creds.password, completionHandler: { (success, user) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.afterSignInSuccess(creds.username, success, user)
            })
        } else {
            os_log("No creds are stored")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        // Hide the keyboard first
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty{
            if(sender.currentTitle == Constants.LoginScreenConstants.LOGIN_CONST) {
                os_log("logging in user")
                self.showSpinner(message: "Authenticating...", timeout: 3000)
                self.signInUser(email: email, password: password, completionHandler: { (success, value) in
                    self.saveCredentials(creds: Login(username: email, password: password))
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.afterSignInSuccess(email, success, value)
                })
            } else if(sender.currentTitle == Constants.LoginScreenConstants.REGISTER_CONST) {
                os_log("registering a user")
                print("email: \(email) & password: \(password)")
                self.showSpinner(message: "Registering user...", timeout: 3000)
                self.registerUser(email: email, password: password, completionHandler: { (success, value) in
                    print(value ?? "")
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    let emptyAlert = AlertSet(buttonTitle: "Ok", completionHandler: self.emptyHandler)
                    if success {
                        _ = self.showMessagePrompt(title: "Registration succesfull", message: "A new user has been registered for the user.", actions: [emptyAlert])
                    } else {
                        _ = self.showMessagePrompt(title: "Registration failed", message: "Check the logs for more info.", actions: [emptyAlert])
                    }
                })
            }
        } else {
            let emptyAlert = AlertSet(buttonTitle: "Ok", completionHandler: self.emptyHandler)
            _ = self.showMessagePrompt(title: "Fields missing", message: "Please fill in the username and email before hitting the login button.", actions: [emptyAlert])
        }
    }
    
    @IBAction func choiceControlChanged(_ sender: UISegmentedControl) {
        resetInputFields()
        
        if(sender.selectedSegmentIndex == 0) {
            loginButton.setTitle(Constants.LoginScreenConstants.LOGIN_CONST, for: .normal)
        } else if(sender.selectedSegmentIndex == 1) {
            loginButton.setTitle(Constants.LoginScreenConstants.REGISTER_CONST, for: .normal)
        } else {
            // There are no more controls in choice control segment
            // Show throw a runtime error if index is something
            fatalError("choiceControl segemented control has unknown index selected")
        }
    }
    
    //MARK: Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.view.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        os_log("text field editing session ended",log: OSLog.default, type: .debug)
        
    }
    
    // MARK: Private methods
    
    func registerUser(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("user registration failed. error")
                print(error)
                completionHandler(false, error as AnyObject)
            } else {
                print("new user registration")
                print(user ?? "")
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    
                })
                completionHandler(true, user as AnyObject)
            }
        }
    }
    
    func signInUser(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("user sign in failed. error")
                print(error)
                completionHandler(false, error as AnyObject)
            } else {
                print("new user signed in")
                print(user ?? "")
                completionHandler(true, user as AnyObject)
            }
        }
    }
    
    fileprivate func navigateToHomeView() {
        
        os_log("trying to navigate home", log: OSLog.default, type: .debug)
        self.performSegue(withIdentifier: Constants.Segues.ShowHomeSegue, sender: self)
        
    }
    
    func resetInputFields() {
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    // MARK: Helper methods
    
    func showMessagePrompt(title: String, message: String, actions: [AlertSet]) ->  UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions {
                alert.addAction(UIAlertAction(title: action.buttonTitle, style: UIAlertActionStyle.default, handler: action.completionHandler))
        }
        
        self.present(alert, animated: true, completion: nil)
        
        return alert
    }
    
    func showSpinner(message: String, timeout: Int) {
        let activityData = ActivityData(message: message, type: NVActivityIndicatorType.ballPulseSync)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    // MARK: Overridden methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    // MARK: - Private methods
    
    private func saveCredentials(creds: Login!) {
        
        if let creds = creds {
            
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(creds, toFile: Login.ArchiveURL.path)
            
            if isSuccessfulSave {
                os_log("Creds successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save creds...", log: OSLog.default, type: .error)
            }
        }
        
    }
    
    private func loadCreds() -> Login? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Login.ArchiveURL.path) as? Login
    }
    
    fileprivate func afterSignInSuccess(_ email: String, _ success: Bool, _ user: AnyObject?) {
        if success {
            print("user email verified?: \(String(describing: user?.isEmailVerified))")
            if let _ = user?.isEmailVerified {
                let okAlert = AlertSet(buttonTitle: "Ok", completionHandler: okHandler)
                _ = self.showMessagePrompt(title: "Sign in succesfull", message: "The user is signed in succesfully with firebase.", actions: [okAlert])
            } else {
                let email = email
                let okAlert = AlertSet(buttonTitle: "Ok", completionHandler: emptyHandler),
                signUpAlert = AlertSet(buttonTitle: "Sign up", completionHandler: signupHandler)
                _ = self.showMessagePrompt(title: "Sign up pending", message: "Please check your email \(email) to verify your account", actions: [signUpAlert, okAlert])
            }
        } else {
            let okAlert = AlertSet(buttonTitle: "Ok", completionHandler: emptyHandler)
            _ = self.showMessagePrompt(title: "Sign in failed", message: "Check the logs for more info.", actions: [okAlert])
        }
    }
    
    func okHandler(_ action: UIAlertAction) {
        self.navigateToHomeView()
    }
    
    func signupHandler(_ action: UIAlertAction) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                os_log("There is an error in sending out a verification email. Please try later.")
                let okAlert = AlertSet(buttonTitle: "Ok", completionHandler: self.emptyHandler)
                _ = self.showMessagePrompt(title: "Email not sent!", message: "There is an error in sending out a verification email. Please try later.", actions: [okAlert])
            }
            
            os_log("Sent an email for verification")
        })
    }
    
    func emptyHandler(_ action: UIAlertAction) {
        // do nothing
        os_log("Empty handler called.")
    }
    
}

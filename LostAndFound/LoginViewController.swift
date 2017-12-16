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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = NVActivityIndicatorView(frame: self.accessibilityFrame)
        
        // Handle the text field’s user input through delegate callbacks.
        passwordTextField.delegate = self
        
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
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if(sender.currentTitle == Constants.LoginScreenConstants.LOGIN_CONST) {
                os_log("logging in user")
                self.showSpinner(message: "Authenticating...", timeout: 3000)
                self.signInUser(email: email, password: password, completionHandler: { (success, value) in
                    print(value ?? "")
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    if success {
                        _ = self.showMessagePrompt(title: "Sign in succesfull", message: "The user is signed in succesfully with firebase.") {(action) in
                            self.navigateToHomeView()
                        }
                    } else {
                        _ = self.showMessagePrompt(title: "Sign in failed", message: "Check the logs for more info.") {(action) in
                            // Do nothing after showing alert
                        }
                    }
                })
            } else if(sender.currentTitle == Constants.LoginScreenConstants.REGISTER_CONST) {
                os_log("registering a user")
                print("email: \(email) & password: \(password)")
                self.showSpinner(message: "Registering user...", timeout: 3000)
                self.registerUser(email: email, password: password, completionHandler: { (success, value) in
                    print(value ?? "")
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    if success {
                        _ = self.showMessagePrompt(title: "Registration succesfull", message: "A new user has been registered for the user.") { (action) in
                            // Do nothing after showing alert
                        }
                    } else {
                        _ = self.showMessagePrompt(title: "Registration failed", message: "Check the logs for more info.") { (action) in
                            // Do nothing after showing alert
                        }
                    }
                })
                
            }
        } else {
            
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
    
    func makeLoginCall(completion: (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        completion(true, nil)
    }
    
    func registerUser(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("user registration failed. error")
                print(error)
                completionHandler(false, error as AnyObject)
            } else {
                print("new user registration")
                print(user ?? "")
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
    
    func showMessagePrompt(title: String, message: String, completionHandler: @escaping (UIAlertAction) -> ()) ->  UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completionHandler))
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

}


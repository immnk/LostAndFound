//
//  ViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import FirebaseAuth
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var choiceControl: UISegmentedControl!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
                self.signInUser(email: email, password: password, completionHandler: { (success, value) in
                    print(value ?? "")
                    if success {
                        _ = self.showMessagePrompt(title: "Sign in succesfull", message: "The user is signed in succesfully with firebase.")
                    } else {
                        _ = self.showMessagePrompt(title: "Sign in failed", message: "Check the logs for more info.")
                    }
                })
            } else if(sender.currentTitle == Constants.LoginScreenConstants.REGISTER_CONST) {
                os_log("registering a user")
                print("email: \(email) & password: \(password)")
                self.registerUser(email: email, password: password, completionHandler: { (success, value) in
                    print(value ?? "")
                    if success {
                        _ = self.showMessagePrompt(title: "Registration succesfull", message: "A new user has been registered for the user.")
                    } else {
                        _ = self.showMessagePrompt(title: "Registration failed", message: "Check the logs for more info.")
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
    
    func showMessagePrompt(title: String, message: String) ->  UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return alert
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


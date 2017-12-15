//
//  ViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var emailTextField: CustomTextField!
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
        passwordTextField.resignFirstResponder()
        
        if(sender.currentTitle == "Login") {
            
        } else if(sender.currentTitle == "Register") {
            
        }
    }
    
    @IBAction func choiceControlChanged(_ sender: UISegmentedControl) {
        resetInputFields()
        
        if(sender.selectedSegmentIndex == 0) {
            loginButton.setTitle("Login", for: .normal)
//            loginButton.currentTitle = "Login"
        } else if(sender.selectedSegmentIndex == 1) {
            loginButton.setTitle("Register", for: .normal)
//            loginButton.currentTitle = "Register"
        } else {
            // There are no more controls in choice control segment
            // Show throw a runtime error if index is something
            fatalError("choiceControl segemented control has unknown index selected")
        }
    }
    
    //MARK: Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        os_log("text field editing session ended",log: OSLog.default, type: .debug)
        
        // Data is entered and return is hit
//        makeLoginCall()
    }
    
    // MARK: Private methods
    
    func makeLoginCall(completion: (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        completion(true, nil)
    }
    
    func registerUser(email: String, password: String, completionHandler: (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        completionHandler(true, nil)
    }
    
    fileprivate func navigateToHomeView() {
        
        os_log("trying to navigate home", log: OSLog.default, type: .debug)
        
        self.performSegue(withIdentifier: Constants.Segues.ShowHomeSegue, sender: self)
        
//        if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//            self.navigationController?.pushViewController(homeViewController, animated: true)
//        } else {
//            os_log("couldnt find the view controller", log: OSLog.default, type: .debug)
//        }
    }
    
    func resetInputFields() {
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }

}


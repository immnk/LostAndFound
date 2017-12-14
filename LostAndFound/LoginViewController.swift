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
    @IBOutlet weak var pinTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        pinTextField.delegate = self
        
//        // Hide the navigation bar on this page
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func login(_ sender: Any) {
        // Hide the keyboard first
        pinTextField.resignFirstResponder()
        
        if makeLoginCall() {
            navigateToHomeView()
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
        
        // Data is entered and login button is clicked.
        if makeLoginCall() {
            navigateToHomeView()
        }
    }
    
    // MARK: Private methods
    
    func makeLoginCall() -> Bool {
        return true;
    }
    
    fileprivate func navigateToHomeView() {
        
        os_log("trying to navigate home", log: OSLog.default, type: .debug)
        
        if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        } else {
            os_log("couldnt find the view controller", log: OSLog.default, type: .debug)
        }
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


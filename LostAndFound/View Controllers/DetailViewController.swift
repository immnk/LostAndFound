//
//  DetailViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/16/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import os.log

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoImagePicker: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        
        usernameLabel.text = Auth.auth().currentUser?.displayName ?? ""
        
        updateSaveButtonState()
        configureDatabase()
        configureStorage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        // Configure the destination view controller only when the save button is pressed.
//        guard let button = sender as? UIBarButtonItem, button === saveButton else {
//            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
//            return
//        }
//
//    }
    
    // MARK: - Actions
    
    @IBAction func selectImageFromGallery(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        returnToOwningController()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let title = titleTextField.text else { return }
        
        var data: [String:String] = [:]
        data[Constants.MessageFields.TITLE_KEY] = title
        data[Constants.MessageFields.DESCRIPTION_KEY] = descriptionTextView.text ?? ""
        
        let image = photoImagePicker.image
        let imageData = UIImageJPEGRepresentation(image!, 0.8)
        let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.showSpinner(message: "Uploading data...", timeout: 2000)
        self.storageRef.child(imagePath)
            .putData(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                guard let strongSelf = self else { return }
                data[Constants.MessageFields.imageURL] = strongSelf.storageRef.child((metadata?.path)!).description
                strongSelf.sendMessage(withData: data)
                
                strongSelf.returnToOwningController()
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImagePicker.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mealNameLabel.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    fileprivate func returnToOwningController() {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The DetailViewController is not inside a navigation controller.")
        }
    }
    
    func showSpinner(message: String, timeout: Int) {
        let activityData = ActivityData(message: message, type: NVActivityIndicatorType.ballPulseSync)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email
        if let photoURL = Auth.auth().currentUser?.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
}

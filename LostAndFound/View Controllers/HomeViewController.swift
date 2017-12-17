//
//  HomeViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import Firebase
import os.log

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    var storageRef: StorageReference!

    @IBOutlet weak var clientTable: UITableView!
    @IBOutlet weak var LoginBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial set up to remove back button
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        
        setLoginBackground()
        self.clientTable.register(LostItemTableViewCell.self, forCellReuseIdentifier: Constants.HomeScreenConstants.LostItemCellIdentifier)
        
        configureDatabase()
        configureStorage()

    }
    
    deinit {
        if (_refHandle) != nil {
            self.ref.child("messages").removeObserver(withHandle: _refHandle)
        }
    }
    
    // MARK: - Actions
    
//    @IBAction func unwindToItemsList(sender: UIStoryboardSegue) {
//
//    }
    
    // MARK: - Table delegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.clientTable .dequeueReusableCell(withIdentifier: Constants.HomeScreenConstants.LostItemCellIdentifier, for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
            if imageURL.hasPrefix("gs://") {
                Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage.init(data: data!)
                        cell.setNeedsLayout()
                    }
                }
            } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage.init(data: data)
            }
            cell.textLabel?.text = "sent by: \(name)"
        } else {
            let text = message[Constants.MessageFields.TITLE_KEY] ?? ""
            cell.textLabel?.text = name + ": " + text
            cell.imageView?.image = UIImage(named: "Placceholder")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
                let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        return cell
    }

    // MARK: - Private Methods
    
    private func setLoginBackground() {
        // Set the image of the header
        
        LoginBackground.image = UIImage(named: "morning")
        
        os_log("testing date time")
        let date = Date()
        let calendar = Calendar.current
        guard let hour = calendar.dateComponents([.hour, .minute], from: date).hour else {
            fatalError("Couldn't get the hour of the date")
        }
        
        switch hour {
        case 6..<10:
            LoginBackground.image = UIImage(named: "morning")
        case 10..<17:
            LoginBackground.image = UIImage(named: "noon")
        case 17..<20:
            LoginBackground.image = UIImage(named: "evening")
        default:
            LoginBackground.image = UIImage(named: "night")
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Configure methods
    
    func configureDatabase() {
        ref = Database.database().reference()
        
        //Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
}

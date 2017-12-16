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

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var LoginBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial set up to remove back button
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        
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
    
}

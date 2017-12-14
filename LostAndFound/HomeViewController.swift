//
//  HomeViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit

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
        
    }
    
}

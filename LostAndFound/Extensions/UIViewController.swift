//
//  UIViewController.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

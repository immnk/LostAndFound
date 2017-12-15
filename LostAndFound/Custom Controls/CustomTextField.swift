//
//  CustomTextField.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/15/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    // MARK: Properties
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var topPadding: CGFloat = 0
    @IBInspectable var bottomPadding: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding))
    }
}

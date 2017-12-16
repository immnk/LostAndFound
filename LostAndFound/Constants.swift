//
//  Constants.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/14/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let ShowHomeSegue = "ShowHomeSegue"
        static let ShowNewItemSegue = "NewItemSegue"
        static let ShowItemDetailSegue = "ShowItemDetailSegue"
    }
    
    struct MessageFields {
        static let name = "name"
        static let title = "title"
        static let description = "description"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
    
    struct LoginScreenConstants {
        static let LOGIN_CONST = "Login"
        static let REGISTER_CONST = "Register"
    }
}

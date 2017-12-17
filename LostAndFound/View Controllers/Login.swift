//
//  Login.swift
//  LostAndFound
//
//  Created by Manikanta Tankala on 12/17/17.
//  Copyright © 2017 Sirius. All rights reserved.
//

import UIKit
import os.log

class Login: NSObject, NSCoding {
    // MARK: Properties
    
    var username: String
    var password: String
    
    //MARK: Types
    
    struct PropertyKey {
        static let username = "username"
        static let password = "password"
    }
    
    //MARK: Initialization
    
    init?(username: String, password: String) {
        guard !username.isEmpty else {
            return nil
        }
        guard !password.isEmpty else {
            return nil
        }
        
        self.username = username
        self.password = password
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(password, forKey: PropertyKey.password)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let username = aDecoder.decodeObject(forKey: PropertyKey.username) as? String else {
            os_log("Unable to decode the username", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String else {
            os_log("Unable to decode the password", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(username: username, password: password)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("credentials")
}

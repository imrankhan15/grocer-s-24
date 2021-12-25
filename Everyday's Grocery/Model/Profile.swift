//
//  Profile.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/11/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class Profile: NSObject, NSCoding {
    
    var password: String
    var moneyUnit: String
    var email: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("profiles")
    
    
    //MARK: Types
    
    struct PropertyKey {
        static let password = "password"
        static let moneyUnit = "moneyUnit"
        static let email = "email"
        
        
    }
    
    //MARK: Initialization
    
    init?(password: String, moneyUnit: String, email: String) {
        
        
        guard !password.isEmpty else {
            return nil
        }
        guard !moneyUnit.isEmpty else {
            return nil
        }
        guard !email.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.password = password
        self.moneyUnit = moneyUnit
        self.email = email
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(moneyUnit, forKey: PropertyKey.moneyUnit)
        aCoder.encode(email, forKey: PropertyKey.email)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let moneyUnit = aDecoder.decodeObject(forKey: PropertyKey.moneyUnit) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let email = aDecoder.decodeObject(forKey: PropertyKey.email) as? String else {
            os_log("Unable to decode the email for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(password: password, moneyUnit: moneyUnit, email: email)
        
    }
    
    
    
}

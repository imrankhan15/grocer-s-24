//
//  Record.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/8/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class Record: NSObject, NSCoding {
    
    var dateTime: String
    var password: String
    var items = [Item]()
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("records")
    
    //MARK: Types
    
    struct PropertyKey {
        static let dateTime = "dateTime"
        static let items = "items"
        static let password = "password"
    }
    
    //MARK: Initialization
    
    init?(dateTime: String, items: [Item], password: String) {
        
        
        guard !dateTime.isEmpty else {
            return nil
        }
        guard !password.isEmpty else {
            return nil
        }
        
        guard !items.isEmpty else {
            return nil
        }
        
        
        // Initialize stored properties.
        self.dateTime = dateTime
        self.items = items
        self.password = password
        
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dateTime, forKey: PropertyKey.dateTime)
        aCoder.encode(items, forKey: PropertyKey.items)
        aCoder.encode(password, forKey: PropertyKey.password)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        
        guard let dateTime = aDecoder.decodeObject(forKey: PropertyKey.dateTime) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let items = aDecoder.decodeObject(forKey: PropertyKey.items) as? [Item] else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
         
        self.init(dateTime: dateTime, items: items, password: password)
    }
    
    
    
    
}

//
//  Item.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 12/29/17.
//  Copyright © 2017 MI Apps. All rights reserved.
//

import UIKit
import os.log

class Item: NSObject, NSCoding {
    
    var estimatedPrice: Float
    var realPrice: Float
    var itemName: String
    var estimatedAmount: Float
    var realAmount: Float
    var unit: String
    var imageURL: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("items")
    
    //MARK: Types
    
    struct PropertyKey {
        static let estimatedPrice = "estimatedPrice"
        static let realPrice = "realPrice"
        static let itemName = "itemName"
        static let estimatedAmount = "estimatedAmount"
        static let realAmount = "realAmount"
        static let unit = "unit"
        static let imageURL = "imageURL"
        
    }
    
    //MARK: Initialization
    
    init?(estimatedPrice: Float, realPrice: Float, itemName: String, estimatedAmount: Float, realAmount: Float, unit: String, imageURL: String) {
        
        
        guard !itemName.isEmpty else {
            return nil
        }
        guard !unit.isEmpty else {
            return nil
        }
        guard estimatedPrice > 0 else {
            return nil
        }
        guard estimatedAmount > 0 else {
            return nil
        }
        guard !imageURL.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.estimatedPrice = estimatedPrice
        self.realPrice = realPrice
        self.itemName = itemName
        self.estimatedAmount = estimatedAmount
        self.realAmount = realAmount
        self.unit = unit
        self.imageURL = imageURL
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(itemName, forKey: PropertyKey.itemName)
        aCoder.encode(unit, forKey: PropertyKey.unit)
        aCoder.encode(estimatedPrice, forKey: PropertyKey.estimatedPrice)
        aCoder.encode(estimatedAmount, forKey: PropertyKey.estimatedAmount)
        aCoder.encode(realPrice, forKey: PropertyKey.realPrice)
        aCoder.encode(realAmount, forKey: PropertyKey.realAmount)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let itemName = aDecoder.decodeObject(forKey: PropertyKey.itemName) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let unit = aDecoder.decodeObject(forKey: PropertyKey.unit) as? String else {
            os_log("Unable to decode the name for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        
        let estimatedAmount = aDecoder.decodeFloat(forKey: PropertyKey.estimatedAmount)
        
        let estimatedPrice = aDecoder.decodeFloat(forKey: PropertyKey.estimatedPrice)
        
        let realAmount = aDecoder.decodeFloat(forKey: PropertyKey.realAmount)
        
        let realPrice = aDecoder.decodeFloat(forKey: PropertyKey.realPrice)
        
        guard let imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURL) as? String else {
            os_log("Unable to decode the url for a Item object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(estimatedPrice: estimatedPrice, realPrice: realPrice, itemName: itemName, estimatedAmount: estimatedAmount, realAmount: realAmount, unit: unit, imageURL: imageURL)
        
    }
    
    
}

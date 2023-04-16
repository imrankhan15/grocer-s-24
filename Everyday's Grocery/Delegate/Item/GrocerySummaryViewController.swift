//
//  GrocerySummaryViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/8/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log


class GrocerySummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var label_total_spent: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var items = [Item]()
    var records = [Record]()
    var record: Record?
    var unitOfMoney: String?
    var password: String?
    var real_items = [Item]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "images_1_.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        saveButton.layer.cornerRadius  = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        update_label_money_spent()
        
        for item in items {
            if item.realAmount > 0.1 {
                real_items.append(item)
            }
        }
        
        if let savedRecords = loadRecords() {
            records += savedRecords
        }
        else {
        }
    }

    
  
    @IBAction func saveAndNew(_ sender: UIButton) {
        
        if real_items.count > 0{
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            let result = formatter.string(from: date)
            record = Record(dateTime: result, items: real_items, password: password!)
            records.append(record!)
            saveRecord()
            items = [Item]()
            saveItems()
}
        
        else {
            items = [Item]()
            saveItems()
        }
        
    }


//MARK: Helper methods
    
    private func loadItems() -> [Item]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    
    private func loadRecords() -> [Record]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Record.ArchiveURL.path) as? [Record]
    }
 
    
    func update_label_money_spent() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.realAmount) * Float(Item.realPrice)
        }
        let alertTitle = NSLocalizedString(" Money Spent : ", comment: "")
        label_total_spent.text =  alertTitle + total.description + " " +   " taka "
    }//unitOfMoney!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func saveRecord() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(records, toFile: Record.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Records successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    func getItemString(item: Item) -> String {
        var realAmountString = ""
        var realPriceString = ""
        realAmountString = item.realAmount.description + " " + item.unit
        realPriceString = item.realPrice.description + " " + "taka " + " "//!unitOfMoney!
        let alertTitle1 = NSLocalizedString(" Item Name: ", comment: "")
        let alertTitle2 = NSLocalizedString(", Bought Amount: ", comment: "")
        let alertTitle3 = NSLocalizedString(", Bought Price: ", comment: "")
        let return_string =  alertTitle1 + item.itemName
            + alertTitle2 + realAmountString + " " + alertTitle3 + realPriceString
        
        return return_string
    }

//MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return real_items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GrocerySummaryTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GrocerySummaryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GrocerySummaryTableViewCell.")
        }
        let item = real_items[indexPath.row]
        cell.itemName.text =  getItemString(item: item)
        cell.selectionStyle = .none
        return cell
    }
}


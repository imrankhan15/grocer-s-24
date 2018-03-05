//
//  GrocerListViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/5/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log

class GrocerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var label_budget: UILabel!
  
    @IBOutlet weak var label_money_spent: UILabel!
    
    var items = [Item]()
    
    var unitOfMoney: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        update_label_budget()
        update_label_money_spent()
        
        self.tableView.separatorStyle = .none

    }
    
    private func loadSampleItems() {
        
        
    }

    
    private func loadItems() -> [Item]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    
    
    func update_label_budget() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.estimatedAmount) * Float(Item.estimatedPrice)
        }
        
        label_budget.text = " Your Estimated Budget : " + total.description + " " + unitOfMoney! + " "
    }

    @IBAction func button_home(_ sender: UIButton) {
        
          dismiss(animated: true, completion: nil)
    }
    func update_label_money_spent() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.realAmount) * Float(Item.realPrice)
        }
        
        label_money_spent.text = " Money Spent : " + total.description + " " + unitOfMoney! + " "
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GrocerListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GrocerListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GrocerListTableViewCell.")
        }
        
        let item = items[indexPath.row]
        
        var realAmountString = ""
        
        var realPriceString = ""
        
        if item.realAmount < 0.1 {
            
            realAmountString = "No Value"
        
        } else {
            
            realAmountString = item.realAmount.description + " " + item.unit
            
        }
        
        
        if item.realPrice < 0.1 {
            
            realPriceString = "No Value"
            
        } else {
            
            realPriceString = item.realPrice.description + " " + unitOfMoney! + " "
            
        }
        
        cell.itemName.text = " Item Name: " + item.itemName
       +  ", Estimated Amount: " + item.estimatedAmount.description + " " + item.unit + ", Estimated Price: " + item.estimatedPrice.description + " " + unitOfMoney! + " " + ", Real Amount: " + realAmountString + " " + ", Real Price: " + realPriceString
        
        return cell
    }
    
    
    
    
    
    
   
    private func saveItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Items successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GrocerListItemViewController, let item = sourceViewController.item {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            
            
            saveItems()
            update_label_budget()
            update_label_money_spent()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowDetailGrocer":
            
            guard let navVc = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let grocerListItemViewController = navVc.viewControllers.first as! GrocerListItemViewController
            
            guard let selectedItemCell = sender as? GrocerListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            grocerListItemViewController.item = selectedItem
            grocerListItemViewController.unitOfMoney = unitOfMoney
            grocerListItemViewController.password = password
            
        case "GrocerySummary":
            
            guard let grocerySummary = segue.destination as? GrocerySummaryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            
           
            
            grocerySummary.items = items
            grocerySummary.unitOfMoney = unitOfMoney
            grocerySummary.password = password
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }

    }
 

}

//
//  HomeListTableViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 12/29/17.
//  Copyright © 2017 MI Apps. All rights reserved.
//

import UIKit
import os.log

class HomeListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet
    var tableView: UITableView!
    @IBOutlet weak var label_budget: UILabel!
    
    @IBOutlet weak var button_gotogrocer: UIButton!
    
    var items = [Item]()

    var unitOfMoney: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))

        items = [Item]()
        
        saveItems()
        
      
    
        update_label_budget()
        
        self.tableView.separatorStyle = .none
        
    }

    func update_label_budget() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.estimatedAmount) * Float(Item.estimatedPrice)
        }
        
        label_budget.text = " Your Estimated Budget : " + total.description + " " + unitOfMoney! + " "
    }
    func editButtonPressed(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    private func loadSampleItems() {
        
       
    }
    // MARK: - Table view data source

   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

  
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cellIdentifier = "HomeListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HomeListTableViewCell.")
        }
        
        let item = items[indexPath.row]
        
       
        cell.itemName.text = "Item Name is: " + item.itemName
        cell.estimatedAmount.text = "Estimated Amount is: " + item.estimatedAmount.description + " " + item.unit + " "
        cell.estimatedPrice.text = "Estimated Price is: " + item.estimatedPrice.description + " " + unitOfMoney! + " "
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            
            saveItems()
            update_label_budget()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = items[sourceIndexPath.row]
        
        items.remove(at: sourceIndexPath.row)
        
        items.insert(movedItem, at: destinationIndexPath.row)
        
        saveItems()
        
         NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(items)")
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
        if let sourceViewController = sender.source as? HomeListItemViewController, let item = sourceViewController.item {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveItems()
            update_label_budget()


        }
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            
            guard let navVc = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            let itemDetailViewController = navVc.viewControllers.first as! HomeListItemViewController
            
            itemDetailViewController.unitOfMoney = unitOfMoney
            itemDetailViewController.password = password
            
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let itemDetailViewController = segue.destination as? HomeListItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedItemCell = sender as? HomeListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
            itemDetailViewController.unitOfMoney = unitOfMoney
            itemDetailViewController.password = password
        
        case "GoToGrocer":
            
            guard let grocerListViewController = segue.destination as? GrocerListViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            
            grocerListViewController.items = items
            grocerListViewController.unitOfMoney = unitOfMoney
            grocerListViewController.password = password
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    private func loadItems() -> [Item]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    @IBAction func gotogrocer_action(_ sender: UIButton) {
    }

}

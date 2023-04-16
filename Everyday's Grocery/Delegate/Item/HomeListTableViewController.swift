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
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var label_budget: UILabel!
    
    @IBOutlet weak var button_gotogrocer: UIButton!
    
    @IBOutlet weak var button_mainPage: UIButton!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    var items = [Item]()
    
    var unitOfMoney: String?
    var password: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundImage = UIImage(named: "images_1_.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        button_mainPage.layer.cornerRadius = 5
        button_gotogrocer.layer.cornerRadius = 5
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        let alertTitle = NSLocalizedString("Edit", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: alertTitle, style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))
        items = [Item]()
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
    
    @IBAction func returnToMain(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func gotogrocer_action(_ sender: UIButton) {
        
    }

}
extension HomeListTableViewController {
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
            print("default")
        }
    }
    
    
    private func loadItems() -> [Item]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    
}

extension HomeListTableViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func loadSampleItems() {
        
        
    }
    
    func getImageFromPath(sender: String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        var image = UIImage()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(sender)
            image    = UIImage(contentsOfFile: imageURL.path)!
            
            return image
           
        }
        
        return image
    }
    
    func update_label_budget() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.estimatedAmount) * Float(Item.estimatedPrice)
        }
        let alertTitle = NSLocalizedString(" Your Estimated Budget : ", comment: "")
        label_budget.text =  alertTitle + total.description + " " + unitOfMoney! + " "
    }
    
    @objc func editButtonPressed(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            let alertTitle = NSLocalizedString("Done", comment: "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: alertTitle, style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))
        }else{
            let alertTitle = NSLocalizedString("Edit", comment: "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: alertTitle, style: .plain, target: self, action: #selector(HomeListTableViewController.editButtonPressed))
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
}
extension HomeListTableViewController {
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
        
        let alertTitle1 = NSLocalizedString("Item Name is: ", comment: "")
        let alertTitle2 = NSLocalizedString("Estimated Amount is: ", comment: "")
        let alertTitle3 = NSLocalizedString("Estimated Price is: ", comment: "")
        cell.itemName.text =  alertTitle1 + item.itemName
        cell.estimatedAmount.text =  alertTitle2 + item.estimatedAmount.description + " " + item.unit + " "
        cell.estimatedPrice.text = alertTitle3 + item.estimatedPrice.description + " " + unitOfMoney! + " "
        
        if item.imageURL.range(of:"noImage") == nil {
            let image = getImageFromPath(sender: item.imageURL) as UIImage
            
            
            cell.cellImage.image = image
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
            items.remove(at: indexPath.row)
            
            saveItems()
            update_label_budget()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedItem, at: destinationIndexPath.row)
        saveItems()
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(items)")
    }
    
}

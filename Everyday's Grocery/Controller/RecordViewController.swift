//
//  RecordViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/10/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import os.log


class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    
   
    var records = [Record]()
    var profile_records = [Record]()
    var copy_records = [Record]()
    var unitOfMoney: String?
    var password: String?
    var email: String?
    var dateTime: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "images_1_.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let alertTitle = NSLocalizedString("Edit", comment: "")
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: alertTitle, style: .plain, target: self, action: #selector(RecordViewController.editButtonPressed))
        
        
      //  tableView.backgroundView = UIImageView(image: UIImage(named: "images_1_.png"))
     //   tableView.backgroundView?.contentMode = .scaleAspectFit

        tableView.separatorStyle = .none
        
        
        
        if let savedRecords = loadRecords() {
            records += savedRecords
        }
            
        else {
            
            
        }
        
        
        
        for rc in records {
            if rc.password == password! {
                profile_records.append(rc)
            }
        }
        
        for rc in records {
            copy_records.append(rc)
        }

        

        // Do any additional setup after loading the view.
    }

    @objc func editButtonPressed(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            let done = NSLocalizedString("Done", comment: "")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: done, style: .plain, target: self, action: #selector(RecordViewController.editButtonPressed))
        }else{
            let edit = NSLocalizedString("Edit", comment: "")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: edit, style: .plain, target: self, action: #selector(RecordViewController.editButtonPressed))
        }
    }


    
    private func loadRecords() -> [Record]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Record.ArchiveURL.path) as? [Record]
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile_records.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RecordTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell.")
        }
        
        let record = profile_records[indexPath.row]
        
        cell.selectionStyle = .none
         let edit = NSLocalizedString("Record Date &Time : ", comment: "")
        cell.record_dateTime.text = edit + record.dateTime
        
         cell.layer.backgroundColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dateTime = profile_records[indexPath.row].dateTime
           profile_records.remove(at: indexPath.row)
            saveRecord()
           
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    private func saveRecord() {
        
        var counter = 0
        for rc in copy_records {
            if rc.dateTime == dateTime {
           //      os_log(records[i].dateTime, log: OSLog.default, type: .debug)
                records.remove(at: counter)
            }
            counter += 1
        }
        counter -= 1
        copy_records.remove(at: counter)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(records, toFile: Record.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Records successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
       
            
        case "ShowRecord":
            
           
            
            guard let recordItemViewController = segue.destination as? RecordItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
            guard let selectedItemCell = sender as? RecordTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecord = profile_records[indexPath.row]
            
            
            recordItemViewController.dateTime = selectedRecord.dateTime
            
            recordItemViewController.items = selectedRecord.items
            
            recordItemViewController.unitOfMoney = unitOfMoney
            
            recordItemViewController.password = password
            
            recordItemViewController.email = email
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

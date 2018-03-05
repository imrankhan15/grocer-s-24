//
//  RecordItemViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/10/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class RecordItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var items = [Item]()
    
    var dateTime:String = ""
    
    var unitOfMoney: String?
    
    var password: String?
    
    @IBOutlet weak var label_total: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "images_1_.png"))
        tableView.backgroundView?.contentMode = .scaleAspectFit
        
        tableView.separatorStyle = .none
        
        update_label_total()
    }

    
    func update_label_total() {
        
        var total = Float(0.0)
        
        for Item in items{
            total += Float(Item.realAmount) * Float(Item.realPrice)
        }
        
        label_total.text = " Total Spent : " + total.description + " " + unitOfMoney! + " "
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RecordItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecordTableViewCell.")
        }
        
         cell.layer.backgroundColor = UIColor.clear.cgColor
        
        let item = items[indexPath.row]
        
        var realAmountString = ""
        
        var realPriceString = ""
        realAmountString = item.realAmount.description + " " + item.unit
        
        realPriceString = item.realPrice.description + " " + unitOfMoney! + " "
        
        cell.itemDetails.text = " Item Name: " + item.itemName
            + ", Bought Amount: " + realAmountString + " " + ", Bought Price: " + realPriceString
        
        return cell
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

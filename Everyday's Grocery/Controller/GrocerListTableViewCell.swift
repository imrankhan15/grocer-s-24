//
//  GrocerListTableViewCell.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/5/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class GrocerListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

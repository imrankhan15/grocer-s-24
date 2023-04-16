//
//  RecordItemTableViewCell.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 1/10/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit

class RecordItemTableViewCell: UITableViewCell {

    @IBOutlet weak var recordItemImage: UIImageView!
    
    @IBOutlet weak var itemDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

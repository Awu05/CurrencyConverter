//
//  TrackedCurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/16/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class TrackedCurrencyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var currencyLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

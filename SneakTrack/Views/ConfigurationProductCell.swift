//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Arpon Purkayastha on 7/6/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class ConfigurationProductCell: UITableViewCell {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var quantity = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        quantity = Int(sender.value)
        quantityLabel.text = "Quantity: \(quantity)"
    }
    
}

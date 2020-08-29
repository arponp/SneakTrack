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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
    }
    
}

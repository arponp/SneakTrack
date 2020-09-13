//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Arpon Purkayastha on 7/6/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import RealmSwift

class ConfigurationProductCell: UITableViewCell {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    
    let realm = try! Realm()
    
    var pData: ProductData?
    var variant: Variants?
    var quantity = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        quantity = Int(sender.value)
                quantityLabel.text = "Quantity: \(quantity)"
                
                let productModel = ProductModel(name: pData!.name, urlKey: pData!.urlKey, thumbnail_url: pData?.thumbnail_url, pid: pData!.pid, size: variant!.size, sid: variant!.uuid, quantity: quantity, highestBid: variant!.market.highestBid, lowestAsk: variant!.market.lowestAsk)
                
        //        write(productModelToSend)
                let pDataInRealm = read()
    }
    
    
    
    
    func write(_ productModel: ProductModel) {
        
        do {
            try realm.write {
                realm.add(productModel)
            }
        } catch {
            print("error saving context: \(error)")
        }
        
    }
    
    func read() -> Results<ProductModel> {
        return realm.objects(ProductModel.self)
    }
    
    func update(productModel: ProductModel,quantity: Int) {
        do {
            try realm.write {
                if quantity == 0 {
                    realm.delete(productModel)
                }
            }
        } catch {
            print("error updating: \(error)")
        }
    }
    
    
    
}

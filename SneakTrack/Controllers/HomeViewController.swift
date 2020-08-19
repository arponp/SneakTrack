//
//  ViewController.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/20/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var inventoryTotalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var pData = [ProductModel]()
    var totalBid = 0
    var totalAsk = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
        
        totalAsk = 0
        totalBid = 0
        
        for shoe in pData {
            totalBid += shoe.productData.variants[shoe.productIndex].market.highestBid
            totalAsk += shoe.productData.variants[shoe.productIndex].market.lowestAsk
        }
        
        inventoryTotalPriceLabel.text = "$\(totalAsk)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentProduct = pData[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "ProductCell")
        
        if let imageUrl = URL(string: currentProduct.productData.thumbnail_url!) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                cell.imageView?.image = UIImage(data: imageData)
            } catch {
                print("Error displaying image")
            }
        }
        
        cell.textLabel?.text = currentProduct.productData.name
        cell.detailTextLabel?.text = "Size: \(currentProduct.size) - Bid: \(currentProduct.productData.variants[currentProduct.productIndex].market.highestBid) & Ask: \(currentProduct.productData.variants[currentProduct.productIndex].market.lowestAsk)"

        return cell
    }

}


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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
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
        
        cell.textLabel?.text = pData[indexPath.row].productData.name 

        return cell
    }

}


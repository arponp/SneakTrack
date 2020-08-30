//
//  ProductCustomizationViewController.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 8/11/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//


import UIKit

class ProductCustomizationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productTitleTextLabel: UILabel!
    
    var searchData: SearchData?
    var pData: ProductData?
    var pDataToSend = [ProductModel]()
    
    override func viewDidLoad() {
        tableView.delegate = self
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addToPortfolio))
        
        tableView.register(UINib(nibName: "ConfigurationProductCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.rowHeight = 100
        
        let urlString = "http://localhost:3001/stockx/product?urlKey=\(searchData!.url)"
        
        // setting image
        if let imageUrl = URL(string: searchData!.thumbnail_url!) {
            do {
                let imageData = try Data(contentsOf: imageUrl)
                imageView.image = UIImage(data: imageData)
            } catch {
                print("Error displaying image")
            }
        }
        
        // making request
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Error: \(error!)")
                }

                if let safeData = data {
                    do {
//                        print(safeData)
                        let decoder = JSONDecoder()
                        self.pData = try decoder.decode(ProductData.self, from: safeData)
                        self.pData?.thumbnail_url = self.searchData?.thumbnail_url
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.productTitleTextLabel.text =  self.pData?.name
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    
}

// MARK: - Table view data source methods
extension ProductCustomizationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pData?.variants.count ?? 0
    }
}

//MARK: - tableview delegate methods
extension ProductCustomizationViewController: UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentProduct = pData!.variants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ConfigurationProductCell
        cell.sizeLabel.text = "Size: \(currentProduct.size)"
        cell.subtitleLabel.text = "Highest bid: \(currentProduct.market.highestBid) & Lowest ask: \(currentProduct.market.lowestAsk)"

        return cell

    }
        
}

//MARK: - Add to Portfolio Methods
extension ProductCustomizationViewController {
    @objc func addToPortfolio() {
        let cells = tableView.visibleCells
        
        for (index,cell) in cells.enumerated() {
            if (cell as! ConfigurationProductCell).quantity > 0 {
                let currentProduct = pData!.variants[index]
                let productModelToSend = ProductModel(productData: pData!, size: currentProduct.size, quantity: (cell as! ConfigurationProductCell).quantity)
                pDataToSend.append(productModelToSend)
            }
        }
        if let rootVC = navigationController?.viewControllers.first as? HomeViewController {
            rootVC.pData = pDataToSend
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

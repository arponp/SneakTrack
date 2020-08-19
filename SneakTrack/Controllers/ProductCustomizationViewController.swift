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
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productTitleTextLabel: UILabel!
    
    var searchData: SearchData?
    var pData: ProductData?
    var quantity = 1
    var pDataToSend: ProductModel?
    
    override func viewDidLoad() {
        tableView.delegate = self
        super.viewDidLoad()
        
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
    
    //MARK: - UIStepper Quantity change
    @IBAction func quantityStepperChanged(_ sender: UIStepper) {
        quantity = Int(sender.value)
        quantityLabel.text = "Quantity: \(quantity)"
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
        
        let currentProduct = pData?.variants[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "ProductCell")

        
        cell.textLabel?.text = "Size: \(String(describing: currentProduct!.size))"
        cell.detailTextLabel?.text = "Highest bid: \(currentProduct!.market.highestBid) & Lowest ask: \(currentProduct!.market.lowestAsk)"
        cell.accessoryType = .disclosureIndicator

        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.popToRootViewController(animated: true)
        pDataToSend = ProductModel(productData: pData!, size: (pData?.variants[indexPath.row].size)!)
//        print(pDataToSend)
        if let rootVC = navigationController?.viewControllers.first as? HomeViewController {
            rootVC.pData.append(pDataToSend!)
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

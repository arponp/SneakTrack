//
//  ProductSearchTableViewController.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/26/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import UIKit



class ProductSearchTableViewController: UITableViewController {
    
    var pData = [SearchData]()

    @IBOutlet weak var productSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Number of rows in section: " + String(pData.count))
        return pData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "ProductCell")
        
        if let imageUrl = URL(string: pData[indexPath.row].media.imageUrl) {
            let imageData = try! Data(contentsOf: imageUrl)
            cell.imageView?.image = UIImage(data: imageData)
        }
        cell.textLabel?.text = pData[indexPath.row].name
        cell.detailTextLabel?.text = pData[indexPath.row].brand
        
        
        return cell
        
        
    }

}

//MARK: - UISearchBarMethods

extension ProductSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text!
        if searchQuery == "" {
            searchBar.placeholder = "Enter a valid search!"
        } else {
            let searchQuerySplit = searchQuery.components(separatedBy: " ")
            print(searchQuerySplit)
            var urlString = ""
            if searchQuerySplit.count > 1 {
                urlString = "http://localhost:3000/stockx/search?keyword="
                for (index,element) in searchQuerySplit.enumerated() {
                    if index == 0 {
                        urlString.append("\(element)%20")
                    } else if index == (searchQuerySplit.count-1) {
                        urlString.append(element)
                    } else {
                        urlString.append("\(element)%20")
                    }
                }
            } else {
                urlString = "http://localhost:3000/stockx/search?keyword=\(searchQuery)"
            }
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print("Error: \(error!)")
                    }

                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            self.pData = try decoder.decode([SearchData].self, from: safeData)
                            print(self.pData.count)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
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
}

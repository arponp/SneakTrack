//
//  ProductSearchTableViewController.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/26/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import UIKit



class ProductSearchTableViewController: UITableViewController {

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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode([SearchData].self, from: safeData)
                            print(decodedData)
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

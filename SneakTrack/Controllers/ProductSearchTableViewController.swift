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
        
        if let imageUrl = URL(string: pData[indexPath.row].thumbnail_url) {
            let imageData = try! Data(contentsOf: imageUrl)
            cell.imageView?.image = UIImage(data: imageData)?.trim()
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

extension UIImage {
    func trim() -> UIImage {
        let newRect = self.cropRect
        if let imageRef = self.cgImage!.cropping(to: newRect) {
            return UIImage(cgImage: imageRef)
        }
        return self
    }
    
    var cropRect: CGRect {
        guard let cgImage = self.cgImage,
            let context = createARGBBitmapContextFromImage(inImage: cgImage) else {
                return CGRect.zero
        }

        let height = CGFloat(cgImage.height)
        let width = CGFloat(cgImage.width)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)

        guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else {
            return CGRect.zero
        }

        var lowX = width
        var lowY = height
        var highX: CGFloat = 0
        var highY: CGFloat = 0
        let heightInt = Int(height)
        let widthInt = Int(width)

        // Filter through data and look for non-transparent pixels.
        for y in 0 ..< heightInt {
            let y = CGFloat(y)

            for x in 0 ..< widthInt {
                let x = CGFloat(x)
                let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */

                if data[Int(pixelIndex)] == 0 { continue } // crop transparent

                if data[Int(pixelIndex+1)] > 0xE0 && data[Int(pixelIndex+2)] > 0xE0 && data[Int(pixelIndex+3)] > 0xE0 { continue } // crop white

                lowX = min(x, lowX)
                highX = max(x, highX)

                lowY = min(y, lowY)
                highY = max(y, highY)
            }
        }

        return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
    }
    
    func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {

        let width = inImage.width
        let height = inImage.height

        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapData = malloc(bitmapByteCount)
        if bitmapData == nil {
            return nil
        }

        let context = CGContext (data: bitmapData,
                                 width: width,
                                 height: height,
                                 bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        return context
    }
}

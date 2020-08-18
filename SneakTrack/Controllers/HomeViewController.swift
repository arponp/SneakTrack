//
//  ViewController.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/20/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var pData = [ProductModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        print(pData)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}


//
//  Product.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 8/3/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import Foundation
import RealmSwift

class ProductModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var urlKey: String = ""
    @objc dynamic var thumbnail_url: String = ""
    @objc dynamic var pid: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var sid: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var highestBid: Int = 0
    @objc dynamic var lowestAsk: Int = 0
    
    init(name: String, urlKey: String, thumbnail_url: String?, pid: String, size: String, sid: String, quantity: Int, highestBid: Int, lowestAsk: Int) {
        self.name = name
        self.urlKey = urlKey
        self.thumbnail_url = thumbnail_url ?? ""
        self.pid = pid
        self.size = size
        self.sid = sid
        self.quantity = quantity
        self.highestBid = highestBid
        self.lowestAsk = lowestAsk
    }
    
    override required init() {
//        fatalError("init() has not been implemented")
    }
    
    
}

// index 0 - size 6 highest bid lowest ask


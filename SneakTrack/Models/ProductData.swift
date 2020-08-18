//
//  DataModel.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/23/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import Foundation

struct ProductData: Codable {
    var name: String
    var urlKey: String
    var pid: String
    var variants: [Variants]
}

struct Variants: Codable {
    var size: String
    var uuid: String
    var market: Market
}

struct Market: Codable {
    var lowestAsk: Int
    var highestBid: Int
}

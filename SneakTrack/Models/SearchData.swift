//
//  SearchData.swift
//  SneakTrack
//
//  Created by Arpon Purkayastha on 7/23/20.
//  Copyright © 2020 Arpon Purkayastha. All rights reserved.
//

import Foundation

struct SearchData: Codable {
    let name: String
    let brand: String
    let url: String
    let product_category: String
    let style_id: String
    let media: Media
}

struct Media: Codable {
    let imageUrl: String
    let smallImageUrl: String
    let thumbUrl: String
}

//
//  ProductData.swift
//  MeliApp
//
//  Created by Lean Caro on 21/12/2020.
//

import Foundation

struct ProductData: Codable {
    
    let results: [Results]
}

struct Results: Codable {
    
    let title: String
    let price: Double
    let currency_id: String
    let condition: String
    let permalink: String
    let thumbnail: String
    
}


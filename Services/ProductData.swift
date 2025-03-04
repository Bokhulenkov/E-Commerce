//
//  ProductData.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

import Foundation

struct ProductData: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}


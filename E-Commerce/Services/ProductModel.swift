//
//  ProductModel.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

import Foundation

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}

//
//  CartItem.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit

struct CartItem {
    let id: UUID
    let image: UIImage?
    let title: String
    let size: String
    let price: Double
    var quantity: Int
}

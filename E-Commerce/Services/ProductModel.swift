//
//  ProductModel.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

import Foundation
import RealmSwift

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rate: Double
}

class ProductRealmModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    @Persisted var price: Double = 0.0
    @Persisted var specification: String = ""
    @Persisted var category: String = ""
    @Persisted var image: String = ""
    @Persisted var rate: Double = 0.0
    @Persisted var isFavorite: Bool = false
    @Persisted var cartCount: Int = 0
    
    convenience init(id: Int, title: String, price: Double, description: String = "", category: String = "", image: String = "", rate: Double = 0.0, isFavorite: Bool = false, cartCount: Int = 0) {
        self.init()
        self.id = id
        self.title = title
        self.price = price
        self.specification = description
        self.category = category
        self.image = image
        self.rate = rate
        self.isFavorite = isFavorite
        self.cartCount = cartCount
    }
}


extension ProductRealmModel {
    static func from(product: ProductModel, realm: Realm) -> ProductRealmModel {
        if let existingProduct = realm.object(ofType: ProductRealmModel.self, forPrimaryKey: product.id) {
            existingProduct.title = product.title
            existingProduct.price = product.price
            existingProduct.specification = product.description
            existingProduct.category = product.category
            existingProduct.image = product.image
            existingProduct.rate = product.rate
            return existingProduct
        } else {
            return ProductRealmModel(
                id: product.id,
                title: product.title,
                price: product.price,
                description: product.description,
                category: product.category,
                image: product.image,
                rate: product.rate,
                isFavorite: false,
                cartCount: 0
            )
        }
    }
}

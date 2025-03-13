//
//  Categories.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

struct DataModel {
    var headerName: String
    var subType: [String]
    var isExpandable: Bool
    var image: String
}

var categories = [
    DataModel(headerName: "Men", subType: ["Pants", "T-shirts", "Jeans", "Shorts", "Jackets", "Shoes", "Hoodies", "Sweaters", "Socks", "Coats"], isExpandable: false, image: "men"),
    DataModel(headerName: "Women", subType: ["Crop Tops", "Dresses", "T-shirts", "Jeans", "Skirts", "Sweaters", "Leggings", "Coats", "Heels", "Bags"], isExpandable: false, image: "women"),
    DataModel(headerName: "Electronics", subType: ["Phones", "Laptops", "Headphones", "Smartwatches", "Tablets", "Monitors", "Keyboards", "Cameras", "Smart Home"], isExpandable: false, image: "electr"),
    DataModel(headerName: "Jewelry", subType: ["Necklaces", "Earrings", "Bracelets", "Rings", "Watches", "Brooches", "Anklets", "Charms", "Pendants"], isExpandable: false, image: "jewel")
]

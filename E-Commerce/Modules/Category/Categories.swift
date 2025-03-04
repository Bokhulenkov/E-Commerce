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

var categories =  [
    DataModel(headerName: "Men", subType: ["Pants", "T-shirts", "Jeans", "Shorts"], isExpandable: false, image: "men"),
    DataModel(headerName: "Women", subType: ["Crop Top", "Dresses", "T-shirts", "Jeans"], isExpandable: false, image: "women"),
    DataModel(headerName: "Electronics", subType: ["Phones", "Laptops", "Headphones", "Smartwatches"], isExpandable: false, image: "electr"),
    DataModel(headerName: "Jewelry", subType: ["Necklaces", "Earrings", "Bracelets", "Rings"], isExpandable: false, image: "jewel")
]

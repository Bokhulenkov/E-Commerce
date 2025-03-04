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
}

var categories =  [
    DataModel(headerName: "Men", subType: ["Pants", "Tshirts", "Jeans", "Shorts"], isExpandable: false),
    DataModel(headerName: "Women", subType: ["Crop Top", "Dresses", "Tshirts", "Jeans"], isExpandable: false),
    DataModel(headerName: "Electronics", subType: ["Phones", "Laptops", "Headphones", "Smartwatches"], isExpandable: false),
    DataModel(headerName: "Jewelry", subType: ["Necklaces", "Earrings", "Bracelets", "Rings"], isExpandable: false)
]

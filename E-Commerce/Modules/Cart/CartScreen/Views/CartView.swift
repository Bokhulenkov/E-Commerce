//
//  CartView.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class CartView {
    private let storageService = StorageService()
    private var cartProducts: [ProductRealmModel] = []
    
    init() {
        loadCartProducts()
    }
    
    func loadCartProducts() {
        cartProducts = storageService.getAllCartProducts()
    }
    
    func getItems() -> [ProductRealmModel] {
        return cartProducts
    }
    
    func updateQuantity(for productId: Int, quantity: Int) {
        storageService.setCart(productId: productId, cartCount: quantity)
        loadCartProducts()
    }
    
    func removeItem(at index: Int) {
        guard index < cartProducts.count else { return }
        let product = cartProducts[index]
        storageService.setCart(productId: product.id, cartCount: 0)
        loadCartProducts()
    }
    
    func removeAll() {
        storageService.clearAllProducts()
        loadCartProducts()
    }
    
    func calculateTotal() -> Double {
        return cartProducts.reduce(0) { $0 + ($1.price * Double($1.cartCount)) }
    }
    
    func calculateCartCount() -> Int {
        return cartProducts.reduce(0) { $0 + $1.cartCount }
    }
    
}

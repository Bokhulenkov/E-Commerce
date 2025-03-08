//
//  CartView.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class CartView {
    private var items: [CartItem] = [
        CartItem(id: UUID(), image: UIImage(named: "bags01"), title: "Lorem ipsum dolorghghghg sit amet consectetur.", size: "M", price: 18.00, quantity: 1),
        CartItem(id: UUID(), image: UIImage(named: "bags02"), title: "Lorem ipsum dolorghfgfgf sit amet consectetur.", size: "L", price: 17.00, quantity: 1),
        CartItem(id: UUID(), image: UIImage(named: "bags01"), title: "Lorem ipsum dolor sit amet consectetur.", size: "XL", price: 18.00, quantity: 1),
        CartItem(id: UUID(), image: UIImage(named: "bags02"), title: "Lorem ipsum dolor sit amet consectetur.", size: "XXL", price: 17.00, quantity: 1)
    
    ]
    
    func getItems() -> [CartItem] {
        return items
    }
    
    func updateQuantity(for id: UUID, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].quantity = quantity
        }
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
    }
    
    func calculateTotal() -> Double {
        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
}

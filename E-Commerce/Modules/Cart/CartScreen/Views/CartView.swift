//
//  CartView.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

import RealmSwift

final class CartView {
    private let storageService = StorageService()
    private var cartProducts: Results<ProductRealmModel>?
    private var notificationToken: NotificationToken?

    init() {
        loadCartProducts()
        observeCartChanges()
    }

    // Загружаем только те продукты, у которых > 0
    func loadCartProducts() {
        let realm = try! Realm()
        cartProducts = realm.objects(ProductRealmModel.self).filter("cartCount > 0")
    }

    // Наблюдаем за изменениями в корзине
    private func observeCartChanges() {
        notificationToken = cartProducts?.observe { [weak self] changes in
            switch changes {
            case .initial:
                print("Cart initialized with \(self?.cartProducts?.count ?? 0) items")
            case .update(_, let deletions, let insertions, let modifications):
                print("Cart updated. Deletions: \(deletions.count), Insertions: \(insertions.count), Modifications: \(modifications.count)")
                NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
            case .error(let error):
                print("Realm observation error: \(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    // Возвращаем все товары в корзине
    func getItems() -> [ProductRealmModel] {
        return cartProducts?.map { $0 } ?? []
    }


    func updateQuantity(for productId: Int, quantity: Int) {
        guard let product = cartProducts?.first(where: { $0.id == productId }), product.cartCount != quantity else {
            return
        }
        storageService.setCart(productId: productId, cartCount: quantity)
    }

    // Удаляем товар из корзины
    func removeItem(at index: Int) {
        guard let product = cartProducts?[index] else { return }
        storageService.setCart(productId: product.id, cartCount: 0)
    }

    // Очищаем корзину
    func removeAll() {
        storageService.clearAllProducts()
    }

    // Вычисляем общую сумму в корзине
    func calculateTotal() -> Double {
        return cartProducts?.reduce(0) { $0 + ($1.price * Double($1.cartCount)) } ?? 0
    }

    // Вычисляем количество товаров в корзине
    func calculateCartCount() -> Int {
        return cartProducts?.reduce(0) { $0 + $1.cartCount } ?? 0
    }
}

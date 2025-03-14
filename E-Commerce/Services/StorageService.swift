//
//  StorageService.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 06.03.2025.
//

import RealmSwift
import Foundation

final class StorageService {
    static let shared = StorageService()
    private var realm: Realm
    private let config = Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: ProductRealmModel.className()) { oldObject, newObject in
                    newObject?["availableCount"] = 50
                }
            }
        }
    )
    
    init() {
        do {
            Realm.Configuration.defaultConfiguration = config
            self.realm = try Realm()
        } catch {
            fatalError("Ошибка при инициализации Realm: \(error)")
        }
    }
        
    func saveProducts(_ products: [ProductModel]) {
            do {
                try realm.write {
                    for product in products {
                        let realmProduct = ProductRealmModel.from(product: product, realm: realm)
                        realm.add(realmProduct, update: .modified)
                    }
                }
            } catch {
                print("Ошибка при сохранении данных: \(error)")
            }
        }
        
        
    func getAllProducts() -> [ProductRealmModel] {
        let products = realm.objects(ProductRealmModel.self)
        return Array(products)
    }
    
    func getAllFavoriteProducts() -> [ProductRealmModel] {
        let favoriteProducts = realm.objects(ProductRealmModel.self).filter("isFavorite == true")
        return Array(favoriteProducts)
    }
    
    func getAllCartProducts() -> [ProductRealmModel] {
        let cartProducts = realm.objects(ProductRealmModel.self).filter("cartCount > 0")
        return Array(cartProducts)
    }
    
    func getCartCountProducts() -> Int {
        var count = 0
        let cartProducts = realm.objects(ProductRealmModel.self).filter("cartCount > 0")
        for product in cartProducts {
            count += product.cartCount
        }
        return count
    }
    
    func clearAllProducts() {
        do {
            try realm.write {
                realm.delete(realm.objects(ProductRealmModel.self))
            }
        } catch {
            print("Ошибка при очистке данных: \(error)")
        }
    }
    
    func setFavorite(productId: Int, isFavorite: Bool) {
        do {
            try realm.write {
                if let product = realm.object(ofType: ProductRealmModel.self, forPrimaryKey: productId) {
                    product.isFavorite = isFavorite
                } else {
                    print("Продукт с id \(productId) не найден")
                }
            }
        } catch {
            print("Ошибка при изменении isFavorite: \(error)")
        }
    }
    
    func setCart(productId: Int, cartCount: Int) {
        do {
            try realm.write {
                if let product = realm.object(ofType: ProductRealmModel.self, forPrimaryKey: productId) {
                    product.cartCount = cartCount
                } else {
                    print("Продукт с id \(productId) не найден")
                }
            }
        } catch {
            print("Ошибка при изменении isCart: \(error)")
        }
    }
    
    func setAvailable(productId: Int, change: Int) {
        do {
            try realm.write {
                if let product = realm.object(ofType: ProductRealmModel.self, forPrimaryKey: productId) {
                    product.availableCount += change
                } else {
                    print("Продукт с id \(productId) не найден")
                }
            }
        } catch {
            print("Ошибка при изменении isCart: \(error)")
        }
    }
    
    func clearCart() {
        do {
            try realm.write {
                let cartProducts = realm.objects(ProductRealmModel.self).filter("cartCount > 0")
                for product in cartProducts {
                    product.cartCount = 0
                }
            }
        } catch {
            print("Ошибка при очистке корзины: \(error)")
        }
    }
}

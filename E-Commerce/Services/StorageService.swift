//
//  StorageService.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 06.03.2025.
//

import RealmSwift
import Foundation

final class StorageService {
    private var realm: Realm
        
    init() {
        do {
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
        let cartProducts = realm.objects(ProductRealmModel.self).filter("isCart == true")
        return Array(cartProducts)
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
    
    func setCart(productId: Int, isCart: Bool) {
        do {
            try realm.write {
                if let product = realm.object(ofType: ProductRealmModel.self, forPrimaryKey: productId) {
                    product.isCart = isCart
                } else {
                    print("Продукт с id \(productId) не найден")
                }
            }
        } catch {
            print("Ошибка при изменении isCart: \(error)")
        }
    }
}

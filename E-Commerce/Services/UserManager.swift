//
//  UserManager.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 15.03.2025.
//
import Foundation

final class UserManager {
    static let shared = UserManager()
    
    init() {}
    
    var userUID: String = ""
    var favorites: [Int] = []
    var cart: [Int] = []
    var cartCount: [Int] = []
    
    func setFavorites(_ id: Int, _ state: Bool) {
        userUID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        if userUID != "" {
            let products = StorageService.shared.getAllFavoriteProducts()
            
            favorites.removeAll()
            for product in products {
                favorites.append(product.id)
            }
            
            FirebaseService.shared.saveUserData(userId: userUID, userData: ["favorites": favorites as [Int]]) { result in
                print("save favorites data")
            }
        }
    }
    
    func setCart(_ id: Int, _ count: Int) {
        userUID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        if !userUID.isEmpty {
            let products = StorageService.shared.getAllCartProducts()
            
            cart.removeAll()
            cartCount.removeAll()
            for product in products {
                cart.append(product.id)
                cartCount.append(product.cartCount)
            }
            
            FirebaseService.shared.saveUserData(userId: userUID, userData: ["cart": cart]) { result in
                print("save cart data")
            }
            
            FirebaseService.shared.saveUserData(userId: userUID, userData: ["cartCount": cartCount]) { result in
                print("save cartCount data")
            }
        }
    }
    
    func clearAllCart() {
        print("clearAllCart")
        userUID = UserDefaults.standard.string(forKey: "userID") ?? ""
        
        if !userUID.isEmpty {
            FirebaseService.shared.saveUserData(userId: userUID, userData: ["cart": []]) { result in
                print("save cart data")
            }
            
            FirebaseService.shared.saveUserData(userId: userUID, userData: ["cartCount": []]) { result in
                print("save cartCount data")
            }
        }
    }
}

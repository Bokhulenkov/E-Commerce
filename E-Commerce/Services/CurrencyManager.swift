//
//  CurrencyManager.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 10.03.2025.
//

import Foundation

class CurrencyManager {
    static let shared = CurrencyManager()
    
    private let currencyKey = "selectedCurrency"
    
    func getCurrency() -> String {
        return UserDefaults.standard.string(forKey: currencyKey) ?? "$"
    }
    
    func saveCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: currencyKey)
    }
}

extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}

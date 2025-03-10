//
//  UserDefaults.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 09.03.2025.
//

import Foundation

class HistoryManager {

    private let maxSearchHistoryCount = 15
    private let searchHistoryKey = "searchHistory"

    private func getSearchHistory() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: searchHistoryKey) as? [String] ?? []
    }

    private func saveSearchHistory(_ history: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(history, forKey: searchHistoryKey)
    }

    func addSearchQuery(_ query: String) {
        var currentHistory = getSearchHistory()

        currentHistory.insert(query, at: 0)

        if currentHistory.count > maxSearchHistoryCount {
            currentHistory = Array(currentHistory.prefix(maxSearchHistoryCount))
        }

        saveSearchHistory(currentHistory)
    }

    func clearSearchHistory() {
        saveSearchHistory([])
    }

    func getAllSearchHistory() -> [String] {
        return getSearchHistory()
    }
}

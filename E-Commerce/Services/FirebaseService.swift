//
//  FirebaseService.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 10.03.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseService {
    static let shared = FirebaseService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Авторизация
    
    func signIn(completion: @escaping (Result<User, Error>) -> Void) {
        auth.signInAnonymously() { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    // MARK: - Firestore Database
    
    func saveUserData(userId: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getUserData(userId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let data = document.data() {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
            }
        }
    }
}

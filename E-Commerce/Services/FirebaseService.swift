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
    
    func createUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func authUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: newPassword) { error in
                completion(error)
            }
        } else {
            completion(NSError(domain: "Firebase", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
        }
    }
    
    func updateEmail(newEmail: String, completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: newEmail) { error in
                completion(error)
            }
        } else {
            completion(NSError(domain: "Firebase", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
        }
    }
    
    func updateDisplayName(newName: String, completion: @escaping (Error?) -> Void) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = newName
            changeRequest.commitChanges { error in
                completion(error)
            }
        } else {
            completion(NSError(domain: "Firebase", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
        }
    }

    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }

    func getCurrentUser(completion: @escaping (User?) -> Void) {
        let user = Auth.auth().currentUser
        completion(user)
    }
    
    // MARK: - Firestore Database
    
    func saveUserData(userId: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).setData(userData, merge: true) { error in
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

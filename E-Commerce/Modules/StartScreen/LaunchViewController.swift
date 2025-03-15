//
//  LaunchViewController.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 14.03.2025.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LaunchViewController: UIViewController {

    private lazy var bagPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Start")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDatabase()
        checkUserAuthentication()
    }
    
    private func checkUserAuthentication() {
        FirebaseService.shared.getCurrentUser { user in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let user = user {
                    UserDefaults.standard.set(user.uid, forKey: "userID")
                    self.loadUserData(userId: user.uid)
                    self.showTabBar()
                } else {
                    self.showAuthScreen()
                }
            }
        }
    }
    
    private func loadUserData(userId: String) {
        FirebaseService.shared.getUserData(userId: userId) { result in
            switch result {
            case .success(let userData):
                print("Данные пользователя загружены: \(userData)")
            case .failure(let error):
                print("Ошибка загрузки данных: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadDatabase() {
        let products = StorageService.shared.getAllProducts()
        if products.isEmpty {
            print("База данных пуста")
        } else {
            print("Данные загружены из Realm")
        }
    }
    
    private func showTabBar() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalTransitionStyle = .flipHorizontal
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true, completion: nil)
    }
    
    private func showAuthScreen() {
        let authVC = StartScreenViewController()
        authVC.modalTransitionStyle = .crossDissolve
        authVC.modalPresentationStyle = .fullScreen
        self.present(authVC, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(bagPicture)
        NSLayoutConstraint.activate([
            bagPicture.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bagPicture.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bagPicture.topAnchor.constraint(equalTo: view.topAnchor),
            bagPicture.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//#Preview { LaunchViewController() }

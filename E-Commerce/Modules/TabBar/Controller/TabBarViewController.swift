//
//  TabBarViewController.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 03.03.2025.
//

import UIKit

class TabBarViewController: UITabBarController {

    let homeVC = HomeViewController()
    let wishlistVC = WishlistViewController()
    let cartVC = CartViewController()
    let settingsVC = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.masksToBounds = false
        
        homeVC.tabBarItem.image = UIImage(resource: .homeTab)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        wishlistVC.tabBarItem.image = UIImage(resource: .wishlistTab)
        wishlistVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        cartVC.tabBarItem.image = UIImage(resource: .cartTab)
        cartVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        settingsVC.tabBarItem.image = UIImage(resource: .settingsTab)
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        viewControllers = [homeVC, wishlistVC, cartVC, settingsVC]
    }

}

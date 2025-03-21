//
//  TabBarViewController.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 03.03.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let storageService = StorageService()
    
    let homeVC = HomeViewController()
    let wishlistVC = WishlistViewController()
    let categoryVC = CategoryViewController()
    let cartVC = CartViewController()
    let settingsVC = SettingsViewController()
    
    private let indicatorView = UIView()
    private let cartCount = UILabel()
    
    var allProducts: [ProductRealmModel] = []
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount(_:)), name: NSNotification.Name("UpdateCart"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateIndicatorPosition(for: tabBar.items?[selectedIndex])
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        updateIndicatorPosition(for: item)
    }
    
    override var selectedIndex: Int {
        didSet {
            updateIndicatorPosition(for: tabBar.items?[selectedIndex])
        }
    }
    
    private func setupViewControllers() {
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        tabBar.layer.shadowRadius = 1
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.masksToBounds = false
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.image = UIImage(resource: .homeTab)
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let wishlistNav = UINavigationController(rootViewController: wishlistVC)
        wishlistNav.tabBarItem.image = UIImage(resource: .wishlistTab)
        wishlistNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let categoryNav = UINavigationController(rootViewController: categoryVC)
        categoryNav.tabBarItem.image = UIImage(resource: .categories)
        categoryNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        categoryNav.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)
        categoryNav.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        
        cartVC.tabBarItem.image = UIImage(resource: .cartTab)
        cartVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        settingsVC.tabBarItem.image = UIImage(resource: .settingsTab)
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        viewControllers = [homeNav, wishlistNav, categoryNav, cartVC, settingsVC]
        
        addCartCount()
        
        guard let tabBarItems = tabBar.items else { return }
        
        indicatorView.backgroundColor = UIColor.black
        indicatorView.layer.cornerRadius = 2
        tabBar.addSubview(indicatorView)
        
        if let firstItem = tabBarItems.first {
            updateIndicatorPosition(for: firstItem)
        }
    }
    
    private func updateIndicatorPosition(for item: UITabBarItem?) {
        guard let item = item, let index = tabBar.items?.firstIndex(of: item) else { return }
        
        let tabBarItemCount = CGFloat(tabBar.items?.count ?? 1)
        let itemWidth = tabBar.frame.width / tabBarItemCount
        let indicatorWidth: CGFloat = 10
        let indicatorHeight: CGFloat = 3
        let indicatorYPosition: CGFloat = 45
        let itemXPosition = (itemWidth * CGFloat(index)) + (itemWidth / 2) - (indicatorWidth / 2)
        
        UIView.animate(withDuration: 0.2) {
            self.indicatorView.frame = CGRect(x: itemXPosition, y: indicatorYPosition, width: indicatorWidth, height: indicatorHeight)
        }
    }
    
    private func addCartCount() {
        let tabBarItemCount = CGFloat(tabBar.items?.count ?? 1)
        let itemWidth = tabBar.frame.width / tabBarItemCount
        let itemXPosition = itemWidth*4 - itemWidth/2
        
        cartCount.text = "\(storageService.getCartCountProducts())"
        cartCount.textAlignment = .center
        cartCount.font = .custom(font: .ralewayMedium, size: 10)
        cartCount.textColor = .white
        cartCount.backgroundColor = .button
        cartCount.layer.cornerRadius = 8
        cartCount.layer.masksToBounds = true
        cartCount.frame = CGRect(x: itemXPosition, y: 10, width: 16, height: 16)
        tabBar.addSubview(cartCount)
    }
    
    @objc public func updateCartCount(_ notification: Notification) {
        let count = storageService.getCartCountProducts()
        cartCount.isHidden = cartCount.text == "0"
        cartCount.text = "\(count)"
    }
}

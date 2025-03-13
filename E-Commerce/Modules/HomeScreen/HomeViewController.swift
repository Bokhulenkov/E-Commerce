//
//  HomeViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    
    private let storageService = StorageService()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var networkService = NetworkService()
    private var allProducts: [ProductRealmModel] = []
    private var popularProducts: [ProductRealmModel] = []
    private var justForYouProducts: [ProductRealmModel] = []
    private var uniqueCategories: [String] = []
    private var currency: String = "$" {
        didSet {
            collectionPopularView.reloadData()
            collectionProductsView.reloadData()
        }
    }
    private var cartCount: Int {
        get {
            return Int(cartCountLabel.text ?? "0") ?? 0
        }
        set {
            cartCountLabel.text = "\(newValue)"
            cartCountLabel.isHidden = newValue == 0
            NotificationCenter.default.post(name: NSNotification.Name("UpdateCart"), object: nil, userInfo: nil)
        }
    }
    
    private let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(.chartIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cartCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 7)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let deliveryAdressTitle: UILabel = {
        let label = UILabel()
        label.text = "Delivery adress"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .nunito, size: 10)
        label.textColor = .deliveryAddressText
        label.textAlignment = .left
        return label
    }()
    
    private let deliveryAdressButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        button.setTitle("", for: .normal)
        button.setTitleColor(.addressText, for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shopTitle: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.textColor = .text
        label.textAlignment = .left
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .searchFieldBackGround
        textField.layer.cornerRadius = 18
        textField.placeholder = "Search"
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let headerCategoriesView = HeaderWithButtonView()
    lazy var collectionCategoriesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HomeCategoriesViewCell.self, forCellWithReuseIdentifier: "HomeCategoriesViewCell")
        return collectionView
    }()
    
    private let headerPopularView = HeaderWithButtonView()
    lazy var collectionPopularView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.register(HomePopularViewCell.self, forCellWithReuseIdentifier: "HomePopularViewCell")
        return collectionView
    }()
    
    private let headerProductsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Just For You"
        label.font = UIFont.custom(font: .ralewayBold, size: 21)
        label.textColor = .text
        return label
    }()
    lazy var collectionProductsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 13
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HomeProductViewCell.self, forCellWithReuseIdentifier: "HomeProductViewCell")
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    let historyManager = HistoryManager()
    let currencyManager = CurrencyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartButton.addTarget(self, action: #selector(openCartButtonAction), for: .touchUpInside)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        networkService.delegate = self
        networkService.performRequest()
        
        searchTextField.delegate = self
        
        currencyManager.saveCurrency(currency)
        NotificationCenter.default.post(name: .currencyDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavoriteProducts(_:)), name: .updateFavoriteProducts, object: nil)
    }
    
    // текст филд не активен,если не пользуемся, надо доработать
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true

        view.addSubview(cartButton)
        cartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        cartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        cartButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: 31).isActive = true
        
        view.addSubview(deliveryAdressTitle)
        deliveryAdressTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        deliveryAdressTitle.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: 0).isActive = true
        deliveryAdressTitle.heightAnchor.constraint(equalToConstant: 12).isActive = true
        deliveryAdressTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(deliveryAdressButton)
        deliveryAdressButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        deliveryAdressButton.topAnchor.constraint(equalTo: deliveryAdressTitle.bottomAnchor, constant: 0).isActive = true
        deliveryAdressButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        deliveryAdressButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(cartCountLabel)
        cartCountLabel.leftAnchor.constraint(equalTo: cartButton.centerXAnchor, constant: 4).isActive = true
        cartCountLabel.bottomAnchor.constraint(equalTo: cartButton.centerYAnchor, constant: -4).isActive = true
        cartCountLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        cartCountLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        view.addSubview(shopTitle)
        shopTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        shopTitle.topAnchor.constraint(equalTo: cartButton.bottomAnchor, constant: 10).isActive = true
        shopTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        shopTitle.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(searchTextField)
        searchTextField.leftAnchor.constraint(equalTo: shopTitle.rightAnchor, constant: 19).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        searchTextField.topAnchor.constraint(equalTo: cartButton.bottomAnchor, constant: 10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 14).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(headerCategoriesView)
        headerCategoriesView.configure("Categories", "See All", self, #selector(openCategoriesButtonAction))
        headerCategoriesView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        headerCategoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerCategoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        
        scrollView.addSubview(collectionCategoriesView)
        collectionCategoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        collectionCategoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        collectionCategoriesView.topAnchor.constraint(equalTo: headerCategoriesView.bottomAnchor, constant: 10).isActive = true
        collectionCategoriesView.heightAnchor.constraint(equalTo: collectionCategoriesView.widthAnchor, multiplier: 0.6 * CGFloat(ceil(Double(uniqueCategories.count / 2)))).isActive = true
        
        scrollView.addSubview(headerPopularView)
        headerPopularView.configure("Popular", "See All", self, #selector(openPopularButtonAction))
        headerPopularView.topAnchor.constraint(equalTo: collectionCategoriesView.bottomAnchor, constant: 22).isActive = true
        headerPopularView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerPopularView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        
        scrollView.addSubview(collectionPopularView)
        collectionPopularView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionPopularView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionPopularView.topAnchor.constraint(equalTo: headerPopularView.bottomAnchor, constant: 24).isActive = true
        collectionPopularView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(headerProductsLabel)
        headerProductsLabel.topAnchor.constraint(equalTo: collectionPopularView.bottomAnchor, constant: 22).isActive = true
        headerProductsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerProductsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        
        scrollView.addSubview(collectionProductsView)
        collectionProductsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        collectionProductsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        collectionProductsView.topAnchor.constraint(equalTo: headerProductsLabel.bottomAnchor, constant: 10).isActive = true
        collectionProductsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        collectionProductsView.heightAnchor.constraint(equalTo: collectionProductsView.widthAnchor, multiplier: 1.8).isActive = true
    }
    
    //MARK: Func
    
    private func setCountCart() {
        cartCount = storageService.getCartCountProducts()
    }
    
    @objc private func updateFavoriteProducts(_ notification: Notification) {
        allProducts = storageService.getAllProducts()
        
        justForYouProducts = justForYouProducts.map { product in
            if let updatedProduct = allProducts.first(where: { $0.id == product.id }) {
                return updatedProduct
            }
            return product
        }

        collectionProductsView.reloadData()

        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.allProducts = self.allProducts
        }
    }
    
    //MARK: Action
    
    @objc func openCategoriesButtonAction(_ button: UIButton) {
        tabBarController?.selectedIndex = 2
    }
    
    @objc func openPopularButtonAction(_ button: UIButton) {
        let vc = ShopViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.products = popularProducts
        vc.currency = currency
        present(vc, animated: true)
    }
    
    @objc func openCartButtonAction(_ button: UIButton) {
        tabBarController?.selectedIndex = 3
    }
    
}
    
    //MARK: UICollectionViewDelegate
    
    extension HomeViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == collectionCategoriesView {
                let selectedCategory = uniqueCategories[indexPath.row]
                let uniqueProducts = allProducts.filter { $0.category == selectedCategory }
                
                let vc = ShopViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.products = uniqueProducts
                vc.currency = currency
                present(vc, animated: true)
            }
            if collectionView == collectionPopularView {
                let vc = DetailViewController()
                vc.configure(for: popularProducts[indexPath.row]) {
                    let currentProduct = self.popularProducts[indexPath.row]
                    var currentCount = currentProduct.cartCount
                    currentCount += 1
                    
                    self.storageService.setCart(productId: currentProduct.id, cartCount: currentCount)
                    self.setCountCart()
                } likeButtonAction: { liked in
                    let currentProduct = self.popularProducts[indexPath.row]
                    self.storageService.setFavorite(productId: currentProduct.id, isFavorite: liked)
                }
            
                vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.navigationController?.isNavigationBarHidden = false
                    self.navigationItem.backButtonTitle = ""
                return
            }
            
            if collectionView == collectionProductsView {
                let vc = DetailViewController()
                vc.configure(for: justForYouProducts[indexPath.row]) {
                    let currentProduct = self.justForYouProducts[indexPath.row]
                    var currentCount = currentProduct.cartCount
                    currentCount += 1
                    
                    self.storageService.setCart(productId: currentProduct.id, cartCount: currentCount)
                    self.setCountCart()
                    
                } likeButtonAction: { liked in
                    let currentProduct = self.justForYouProducts[indexPath.row]
                    self.storageService.setFavorite(productId: currentProduct.id, isFavorite: liked)
                }
                
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                navigationController?.isNavigationBarHidden = false
                navigationItem.backButtonTitle = ""
                return
            }
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    extension HomeViewController: UICollectionViewDataSource {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == collectionCategoriesView {
                return uniqueCategories.count
            } else if collectionView == collectionPopularView {
                return popularProducts.count
            } else if collectionView == collectionProductsView {
                return justForYouProducts.count > 0 ? 4 : 0
            } else {
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == collectionCategoriesView {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoriesViewCell", for: indexPath) as! HomeCategoriesViewCell
                let uniqueProducts = allProducts.filter { $0.category == uniqueCategories[indexPath.row] }
                let images = uniqueProducts.compactMap { $0.image }
                
                cell.configure(with: "\(uniqueCategories[indexPath.row])", count: uniqueProducts.count, images: images)
                return cell
                
            } else if collectionView == collectionPopularView {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePopularViewCell", for: indexPath) as! HomePopularViewCell
                cell.configure(popularProducts[indexPath.row].image, popularProducts[indexPath.row].title, "\(currency)\(popularProducts[indexPath.row].price)" )
                return cell
                
            } else if collectionView == collectionProductsView {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductViewCell", for: indexPath) as! HomeProductViewCell
                cell.isUserInteractionEnabled = true
                
                cell.configure(justForYouProducts[indexPath.row].image,
                                           justForYouProducts[indexPath.row].title,
                                           "\(currency)\(justForYouProducts[indexPath.row].price)",
                                           justForYouProducts[indexPath.row].isFavorite)
                cell.addButtonAction = {
                    var currentCount = self.justForYouProducts[indexPath.item].cartCount
                    currentCount += 1
                    self.storageService.setCart(productId: self.justForYouProducts[indexPath.item].id, cartCount: currentCount)
                    self.setCountCart()
                }
                
                cell.likeButtonAction = { liked in
                    self.storageService.setFavorite(productId: self.justForYouProducts[indexPath.item].id, isFavorite: liked)
                }
                
                return cell
                
            } else {
                
                return UICollectionViewCell()
            }
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    extension HomeViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == collectionCategoriesView {
                
                let width = (collectionCategoriesView.frame.width - 4) / 2
                let height = width + 30
                return CGSize(width: width, height: height)
                
            } else if collectionView == collectionPopularView {
                
                return CGSize(width: 140, height: 204)
                
            } else if collectionView == collectionProductsView {
                
                let width = (collectionProductsView.frame.width - 13) / 2
                let height = width * 1.75
                return CGSize(width: width, height: height)
                
            } else {
                
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    //MARK: NetworkServiceDelegate
    
    extension HomeViewController: NetworkServiceDelegate {
        func didUpdateData(products: [ProductModel]) {
            
            storageService.saveProducts(products)

            allProducts = storageService.getAllProducts()
            popularProducts = allProducts.sorted { $0.rate > $1.rate }
            justForYouProducts = Array(allProducts.shuffled().prefix(4))
            uniqueCategories = Array(Set(allProducts.map { $0.category }))

            setCountCart()
            
            configureUI()
            
            collectionPopularView.reloadData()
            collectionProductsView.reloadData()
            collectionCategoriesView.reloadData()
            
            if let tabBarController = self.tabBarController as? TabBarViewController {
                tabBarController.allProducts = self.allProducts
            }
        }
        
        func didFailWithError(error: any Error) {
            print("didFailWithError: \(error)")
        }
    }
    
    extension HomeViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let europeanCountries = ["AT", "AL", "AD", "BE", "BG", "BA", "VA", "GB", "HU", "DE", "GR", "DK", "IE", "IS", "ES", "IT", "CY", "LV", "LT", "LI", "LU", "MK", "MT", "MD", "MC", "NL", "NO", "PL", "PT", "RO", "SM", "RS", "SK", "SI", "UA", "FI", "FR", "HR", "ME", "CZ", "CH", "SE", "EE"]
            let americanCountries = ["US", "CA", "MX", "AR", "BR", "CL", "CO", "VE", "PE", "PY", "UY", "BO", "EC", "GT", "HN", "CU", "DO", "PA", "CR", "JM", "SV", "NI", "HT", "TT", "BB", "BZ", "BS", "SR", "GY"]

            if let location = locations.last {
                geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                    guard let self = self else { return }
                                    
                    if let error = error {
                        print("Ошибка геокодирования: \(error.localizedDescription)")
                        return
                    }
                                    
                    if let placemark = placemarks?.first {
                        if let city = placemark.locality {
                            deliveryAdressButton.setTitle("\(city)", for: .normal)
                        } else {
                            print("Город не найден")
                        }
                            
                        if let country = placemark.isoCountryCode {
                            var newCurrency = ""
                            if americanCountries.contains(country) {
                                newCurrency = "$"
                            } else if europeanCountries.contains(country) {
                                newCurrency = "€"
                            } else if country == "RU" {
                                newCurrency = "₽"
                            } else {
                                newCurrency = "$"
                            }
                                
                            if newCurrency != currency {
                                currency = newCurrency
                                print(newCurrency)
                                currencyManager.saveCurrency(newCurrency)
                                NotificationCenter.default.post(name: .currencyDidChange, object: nil)
                            }
                        } else {
                            print("Страна не найдена")
                        }
                    }
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Ошибка при получении местоположения: \(error.localizedDescription)")
        }
    }
    
    //MARK: UITextFieldDelegate
    
    extension HomeViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard let text = textField.text, !text.isEmpty else {
                return false
            }

            let filtered = allProducts.filter {
                        $0.title.lowercased().contains(text.lowercased())
                    }
            
            let historyManager = HistoryManager()
            historyManager.addSearchQuery(text)
            
            let vc = ShopViewController()
            vc.searchedText = text
            vc.products = allProducts
            vc.filteredProducts = filtered
            textField.text = ""
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
            textField.resignFirstResponder()
            return true
        }
    }

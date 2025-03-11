//
//  WishlistViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class WishlistViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Wishlist"
        label.font = .custom(font: .ralewayBold, size: 28)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private lazy var searchContainer: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Search"
        label.font = .custom(font: .ralewayMedium, size: 16)
        label.textAlignment = .left
        label.textColor = .deliveryAddressText
        
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .searchFieldBackGround
        textField.layer.cornerRadius = 18
        textField.borderStyle = .none
        textField.placeholder = ""
        textField.font = .custom(font: .ralewayMedium, size: 16)
        textField.clearButtonMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 25
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WishlistViewCell.self, forCellWithReuseIdentifier: "WishlistViewCell")
        collectionView.allowsMultipleSelection = true
        collectionView.isUserInteractionEnabled = true
        
        return collectionView
    }()
    //MARK: - Properties
    var likeButtonAction: ((Bool) -> Void)?
    var storageService = StorageService()
    var products: [ProductRealmModel] = []
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
     
        setupUI()
        setupKeyboardHandling()
        loadWishlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        loadWishlist()
    }
    
    //MARK: - Methods
    private func loadWishlist() {
        products = storageService.getAllFavoriteProducts()
        collectionView.reloadData()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchLabel)
        searchContainer.addSubview(searchTextField)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    private func  setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            searchContainer.heightAnchor.constraint(equalToConstant: 36),
            
            searchLabel.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 9),
            searchLabel.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 22),
            searchLabel.widthAnchor.constraint(equalToConstant: 60),
            
            searchTextField.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchLabel.trailingAnchor, constant: 10),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 11),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
        cell.configure(products[indexPath.row].image,
                       products[indexPath.row].title,
                       String(format: "%.2f", products[indexPath.row].price),
                       products[indexPath.row].isFavorite)
        cell.addButtonAction = {
            var currentCount = self.products[indexPath.item].cartCount
            currentCount += 1
            self.storageService.setCart(productId: self.products[indexPath.item].id, cartCount: currentCount)
        }
        
        cell.likeButtonAction = { liked in
            self.storageService.setFavorite(productId: self.products[indexPath.item].id, isFavorite: liked)
        }
        
        cell.isUserInteractionEnabled = true
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.isNavigationBarHidden = false
        navigationItem.backButtonTitle = ""
    }
}

//MARK: -  UICollectionViewDelegateFlowLayout
extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 51) / 2
        return CGSize(width: width, height: 282)
    }
}

// MARK: - UITextFieldDelegate
extension WishlistViewController: UITextFieldDelegate {
    func setupKeyboardHandling() {
        searchTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.endEditing(true)
    }
}

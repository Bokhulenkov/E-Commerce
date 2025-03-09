//
//  Shop.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 06.03.2025.
//
import UIKit

final class ShopViewController: UIViewController {
    
    var products: [ProductRealmModel] = []
    var currency: String = ""
    var searchedText = ""
    var filteredProducts: [ProductRealmModel] = []
    
    private let shopTitle: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.textColor = .text
        label.textAlignment = .left
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .searchFieldBackGround
        textField.layer.cornerRadius = 18
        if searchedText.isEmpty {
            textField.placeholder = "Search" } else {
                textField.text = searchedText
            }
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
           button.setImage(UIImage(named: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return button
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
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarViewController {
            currency = tabBarController.currency
        }
        filteredProducts = products

        setupUI()
        searchTextField.delegate = self
    }
}

//MARK: Private methods
private extension ShopViewController {
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(closeButton)
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        view.addSubview(shopTitle)
        shopTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        shopTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        shopTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        shopTitle.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(searchTextField)
        searchTextField.leftAnchor.constraint(equalTo: shopTitle.rightAnchor, constant: 19).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(collectionProductsView)
        collectionProductsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        collectionProductsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        collectionProductsView.topAnchor.constraint(equalTo: shopTitle.bottomAnchor, constant: 10).isActive = true
        collectionProductsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }

    @objc func closeVC() {
        dismiss(animated: true)
    }
}

//MARK: UICollectionViewDelegate

extension ShopViewController: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource

extension ShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return !searchedText.isEmpty ? filteredProducts.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductViewCell", for: indexPath) as! HomeProductViewCell
        
        let dataSource = !searchedText.isEmpty ? filteredProducts : products
                let product = dataSource[indexPath.row]
                
                cell.configure(product.image, product.title, "\(currency)\(product.price)", product.isFavorite)
                
                cell.addButtonAction = {
                    print("Add to cart: \(product.title)")
                }
                
                cell.likeButtonAction = { liked in
                    print("like state \(liked) for \(product.title)")
                }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        // без навбара нет выхода с экрана!
        
        let vc = DetailViewController()
        vc.configure(for: products[indexPath.row])
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            let width = (collectionProductsView.frame.width - 13) / 2
            let height = width * 1.75
            return CGSize(width: width, height: height)
    }
}

extension ShopViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchedText = textField.text?.lowercased() ?? ""
                
                if searchedText.isEmpty {
                    filteredProducts = products
                } else {
                    filteredProducts = products.filter {
                        $0.title.lowercased().contains(searchedText)
                    }
                }

                collectionProductsView.reloadData()
    }
}
    

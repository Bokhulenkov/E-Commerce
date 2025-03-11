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
    let historyManager = HistoryManager()
    let currencyManager = CurrencyManager()
    
    private var searchHistory: [String] = []
    
    private lazy var shopTitle: UILabel = {
        let label = UILabel()
        label.text = "Shop"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.textColor = .text
        label.textAlignment = .left
        return label
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Search history"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayMedium, size: 18)
        label.textColor = .text
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .searchFieldBackGround
        textField.layer.cornerRadius = 18
        textField.placeholder = "Search"
        textField.text = searchedText
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
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "basketIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteHistory), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionProductsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
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
    
    lazy var historyCollectionView: UICollectionView = {
        let layout = CustomLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchHistoryCell.self, forCellWithReuseIdentifier: "SearchHistoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
        searchHistory = historyManager.getAllSearchHistory()
        currency = currencyManager.getCurrency()
        
        setupUI()
        searchTextField.delegate = self
        
        if products == filteredProducts {
            if filteredProducts.isEmpty {
                updateUIWhenEmpty()
            } else {
                collectionProductsView.isHidden = false
                historyLabel.isHidden = true
                deleteButton.isHidden = true
                historyCollectionView.isHidden = true
            }
            
            collectionProductsView.reloadData()
            historyCollectionView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if searchedText.isEmpty {
                filteredProducts = products
            }
        
        if filteredProducts.isEmpty {
                updateUIWhenEmpty()
            }
        
            collectionProductsView.reloadData()
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        view.addSubview(historyLabel)
        view.addSubview(deleteButton)
        
        historyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        historyLabel.topAnchor.constraint(equalTo: shopTitle.bottomAnchor, constant: 10).isActive = true
        historyLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        historyLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        deleteButton.topAnchor.constraint(equalTo: shopTitle.bottomAnchor, constant: 10).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        view.addSubview(historyCollectionView)
        NSLayoutConstraint.activate([
            historyCollectionView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 20),
            historyCollectionView.leadingAnchor.constraint(equalTo: shopTitle.leadingAnchor, constant: 10),
            historyCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21),
            historyCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    func updateUIWhenEmpty() {
        collectionProductsView.isHidden = true
        historyLabel.isHidden = false
        deleteButton.isHidden = false
        historyCollectionView.isHidden = false
    }
    
    private func removeQuery(at index: Int) {
        searchHistory.remove(at: index)
        historyCollectionView.reloadData()
    }
    
    @objc func closeVC() {
        dismiss(animated: true)
    }
    
    @objc func deleteHistory() {
        historyManager.clearSearchHistory()
        searchHistory = []
        historyCollectionView.reloadData()
    }
    
    // Обновляем валюту, если изменилась
    @objc func currencyDidChange() {
        currency = currencyManager.getCurrency()
    }
}

//MARK: UICollectionViewDelegate

extension ShopViewController: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource

extension ShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionProductsView {
            return !searchedText.isEmpty ? filteredProducts.count : products.count
        }
        if collectionView == historyCollectionView {
            return searchHistory.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionProductsView {
            
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
        
        if collectionView == historyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchHistoryCell", for: indexPath) as! SearchHistoryCell
            let query = searchHistory[indexPath.item]
            cell.configure(text: query) { [weak self] in
                self?.removeQuery(at: indexPath.item)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionProductsView {
            let selectedProduct: ProductRealmModel
            if filteredProducts.isEmpty {
                selectedProduct = products[indexPath.row]
            } else {
                selectedProduct = filteredProducts[indexPath.row]
            }
#warning("Временное решение нужно добавить обработку!!!")
            let vc = DetailViewController()
            vc.configure(for: selectedProduct) {
                
            } likeButtonAction: { value in
                
            }

            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchedText = textField.text?.lowercased() ?? ""
        
        if !searchedText.isEmpty {
                   historyManager.addSearchQuery(searchedText)
                   searchHistory = historyManager.getAllSearchHistory()
                   historyCollectionView.reloadData()
               }
        
        if searchedText.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.title.lowercased().contains(searchedText)
            }
        }
        
        collectionProductsView.reloadData()

        if filteredProducts.isEmpty {
            updateUIWhenEmpty()
        } else {
            collectionProductsView.isHidden = false
            historyLabel.isHidden = true
            deleteButton.isHidden = true
            historyCollectionView.isHidden = true
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchedText = ""
        
        if products.isEmpty, let tabBarController = self.tabBarController as? TabBarViewController {
                products = tabBarController.allProducts
            }
      filteredProducts = products
        
        textField.resignFirstResponder()
        
        collectionProductsView.isHidden = false
        historyLabel.isHidden = true
        deleteButton.isHidden = true
        historyCollectionView.isHidden = true
        
        collectionProductsView.reloadData()
        return true
    }
}




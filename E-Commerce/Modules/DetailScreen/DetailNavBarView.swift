//
//  DetailNavBarView.swift
//  E-Commerce
//
//  Created by Анна on 06.03.2025.
//

import UIKit

class DetailNavBarView: UIStackView {
    // MARK: - GUI Variables
    lazy var likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.heartRed, for: .normal)
        button.backgroundColor = .variationsBackground
        button.clipsToBounds = true
        button.layer.cornerRadius = 11
        
        return button
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.layer.cornerRadius = 11
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Buy now", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.layer.cornerRadius = 11
        button.backgroundColor = .button
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.layer.cornerRadius = 11
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.layer.cornerRadius = 11
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Properties
    var addButtonAction: (() -> Void)?
    var likeButtonAction: ((Bool) -> Void)?
    private var isFavorite: Bool = false
    var updateCartAction: (() -> Void)?
    private var product: ProductRealmModel?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupView()
        
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(changeCountButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(changeCountButtonTapped), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    func configure(product: ProductRealmModel, _ target: Any?, _ action: Selector, _ isFavorite: Bool) {
        buyButton.addTarget(target, action: action, for: .touchUpInside)
        self.isFavorite = isFavorite
        self.product = product
        
        isFavorite ? likeButton.setImage(.heartRedFull, for: .normal) : likeButton.setImage(.heartRed, for: .normal)
        
        updateCartCount(product.cartCount)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .white
        axis = .horizontal
        spacing = 16
        distribution = .fillProportionally
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        isLayoutMarginsRelativeArrangement = true
    }
    
    @objc private func likeButtonTapped() {
        isFavorite.toggle()
        likeButtonAction?(isFavorite)
    }
    
    @objc private func addToCartButtonTapped() {
        guard let product = self.product else { return }
        
        let newCount = product.cartCount + 1
        
        StorageService.shared.setCart(productId: product.id, cartCount: newCount)
        
        updateCartCount(newCount)
        addButtonAction?()
    }
    
    @objc private func changeCountButtonTapped(_ sender: UIButton) {
        guard let product = self.product else { return }
        
        let newCount = sender == minusButton ? max(product.cartCount - 1, 0) : product.cartCount + 1
        
        StorageService.shared.setCart(productId: product.id, cartCount: newCount)
        
        updateCartCount(newCount)
        updateCartAction?()
        
        NotificationCenter.default.post(name: NSNotification.Name("UpdateCart"), object: nil, userInfo: nil)
    }
    
    public func updateCartCount(_ count: Int) {
        print(count)
        if count > 0 {
            minusButton.isHidden = false
            plusButton.isHidden = false
            addToCartButton.setTitle("\(count)", for: .normal)
            addToCartButton.backgroundColor = UIColor.systemGreen
        } else {
            minusButton.isHidden = true
            plusButton.isHidden = true
            addToCartButton.setTitle("Add to cart", for: .normal)
            addToCartButton.backgroundColor = .black
        }
        
        addToCartButton.isEnabled = true
    }

    private func setupUI() {
        addArrangedSubview(likeButton)
        addArrangedSubview(addToCartButton)
        addArrangedSubview(buyButton)
        addSubview(minusButton)
        addSubview(plusButton)
        
        setupConstraints()
    }
    
    private func  setupConstraints() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 47),
            
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            addToCartButton.widthAnchor.constraint(equalTo: buyButton.widthAnchor),

            buyButton.heightAnchor.constraint(equalToConstant: 40),
            
            minusButton.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            minusButton.leadingAnchor.constraint(equalTo: addToCartButton.leadingAnchor, constant: 10),
            minusButton.widthAnchor.constraint(equalToConstant: 22),
            minusButton.heightAnchor.constraint(equalToConstant: 22),
            
            plusButton.centerYAnchor.constraint(equalTo: addToCartButton.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: addToCartButton.trailingAnchor, constant: -10),
            plusButton.widthAnchor.constraint(equalToConstant: 22),
            plusButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

//
//  HomeProductViewCell.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 04.03.2025.
//

import UIKit
import Kingfisher

class HomeProductViewCell: UICollectionViewCell {
    
    var addButtonAction: (() -> Void)?
    var likeButtonAction: ((Bool) -> Void)?
    var updateCartAction: (() -> Void)?
    private var product: ProductRealmModel?

    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(red: 0, green: 0.29, blue: 1, alpha: 1)
        return button
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .productTest
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .nunito, size: 12)
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 17)
        label.textColor = .text
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.heartRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(changeCountButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(changeCountButtonTapped), for: .touchUpInside)
        configureCell()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func prepareForReuse() {
        backgroundColor = .clear
        productImageView.image = nil
        productTitle.text = nil
        productPrice.text = nil
    }
    
    private func configureCell() {
        backgroundColor = .clear
        
        addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        productImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.1).isActive = true
        
        addSubview(productTitle)
        productTitle.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 11).isActive = true
        productTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        addSubview(productPrice)
        productPrice.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 1).isActive = true
        productPrice.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productPrice.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productPrice.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        addSubview(likeButton)
        likeButton.centerYAnchor.constraint(equalTo: productPrice.centerYAnchor, constant: 0).isActive = true
        likeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 8).isActive = true
        addButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        addSubview(minusButton)
        minusButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor, constant: 0).isActive = true
        minusButton.leftAnchor.constraint(equalTo: addButton.leftAnchor, constant: 16).isActive = true
        minusButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(plusButton)
        plusButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor, constant: 0).isActive = true
        plusButton.rightAnchor.constraint(equalTo: addButton.rightAnchor, constant: -16).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    public func configure(_ product: ProductRealmModel, currency: String) {
        self.product = product
        
        productTitle.text = "\(product.title)"
        productPrice.text = "\(currency)\(product.price)"
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url)
            productImageView.layer.cornerRadius = 5
        }
        
        let buttonImage = product.isFavorite ? UIImage.heartRedFull : UIImage.heartRed
        likeButton.setImage(buttonImage, for: .normal)
        
        updateCartCount(product.cartCount)
    }
    
    public func updateCartCount(_ count: Int) {
        if count > 0 {
            minusButton.isHidden = false
            plusButton.isHidden = false
            addButton.isEnabled = false
            addButton.setTitle("\(count)", for: .normal)
            addButton.backgroundColor = UIColor.systemGreen
        } else {
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.isEnabled = true
            addButton.setTitle("Add to cart", for: .normal)
            addButton.backgroundColor = UIColor(red: 0, green: 0.29, blue: 1, alpha: 1)
        }
    }
        
    @objc private func addButtonTapped() {
        addButtonAction?()
    }
    
    @objc private func likeButtonTapped() {
        likeButtonAction?(likeButton.currentImage == .heartRed)
        likeButton.currentImage == .heartRed ? likeButton.setImage(.heartRedFull, for: .normal) : likeButton.setImage(.heartRed, for: .normal)
    }
    
    @objc private func changeCountButtonTapped(_ sender: UIButton) {
        if sender == minusButton {
            StorageService.shared.setCart(productId: product?.id ?? 0, cartCount: (product?.cartCount ?? 0) - 1)
        } else {
            StorageService.shared.setCart(productId: product?.id ?? 0, cartCount: (product?.cartCount ?? 0) + 1)
        }
        
        updateCartAction?()
        updateCartCount(product?.cartCount ?? 0)
        
        NotificationCenter.default.post(name: NSNotification.Name("UpdateCart"), object: nil, userInfo: nil)
    }
}

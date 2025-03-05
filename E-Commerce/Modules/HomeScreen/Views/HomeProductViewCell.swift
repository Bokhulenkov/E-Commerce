//
//  HomeProductViewCell.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 04.03.2025.
//

import UIKit

class HomeProductViewCell: UICollectionViewCell {
    
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet consectetur"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .nunito, size: 12)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.text = "$17,00"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(.likeButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        likeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 8).isActive = true
        addButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
    }
}

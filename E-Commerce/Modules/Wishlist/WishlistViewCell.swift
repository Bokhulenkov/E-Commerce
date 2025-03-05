//
//  WishlistViewCell.swift
//  E-Commerce
//
//  Created by Анна on 04.03.2025.
//

import UIKit

class WishlistViewCell: UICollectionViewCell {
    // MARK: - GUI Variables
    private lazy var shadowView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.102
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 9
        view.clipsToBounds = false
        
        return view
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "photoImage")
        imageView.layer.cornerRadius = 9
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Lorem ipsum dolor sit amet consectetur"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .regular)
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "$17,00"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        button.layer.cornerRadius = 4
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private lazy var likeImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "likeImage")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(shadowView)
        addSubview(photoImageView)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        addSubview(cartButton)
        addSubview(likeImage)
        
        setupConstraints()
    }
    
    private func  setupConstraints() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 181),
            
            photoImageView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 5),
            photoImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 5),
            photoImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -5),
            photoImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 6),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 1),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            cartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 6),
            cartButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 31),
            cartButton.widthAnchor.constraint(equalToConstant: 120),
            cartButton.trailingAnchor.constraint(equalTo: likeImage.leadingAnchor, constant: -18),
            
            likeImage.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            likeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            likeImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            likeImage.heightAnchor.constraint(equalToConstant: 20),
            likeImage.widthAnchor.constraint(equalToConstant: 22),
        ])
    }
}

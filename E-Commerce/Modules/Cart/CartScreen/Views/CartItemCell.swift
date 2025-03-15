//
//  CartItemCell.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit
import Kingfisher

final class CartItemCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sizeLabel = UILabel()
    private let priceLabel = UILabel()
    private let counterLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .custom)
    private let counterContainerView = UIView()
    private let shadowContainerView = UIView()
    
    var onDelete: (() -> Void)?
    var onQuantityChanged: ((Int, Int) -> Void)? // Передаем (productId, quantity)
    
    private var productId: Int?
    private var quantity = 1 {
        didSet {
            counterLabel.text = "\(quantity)"
            updateMinusButtonState()
        }
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func updateMinusButtonState() {
        if quantity <= 1 {
            minusButton.isEnabled = false
            minusButton.setTitleColor(.lightGray, for: .normal)
            minusButton.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            minusButton.isEnabled = true
            minusButton.setTitleColor(.blue, for: .normal)
            minusButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    // MARK: - Configuration
    
    func configure(productId: Int, image: String?, title: String, size: String, price: String, quantity: Int) {
        self.productId = productId
        self.quantity = quantity
        counterLabel.text = "\(quantity)"
        updateMinusButtonState()
        
        if let imageUrl = image, let url = URL(string: imageUrl) {
            itemImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = title
        sizeLabel.text = "Size: \(size)"
        priceLabel.text = price
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        [shadowContainerView, titleLabel, sizeLabel, priceLabel, deleteButton, minusButton, counterContainerView, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
            
            shadowContainerView.addSubview(itemImageView)
            itemImageView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8
        itemImageView.layer.masksToBounds = true
        
        shadowContainerView.translatesAutoresizingMaskIntoConstraints = false
        shadowContainerView.layer.backgroundColor = UIColor.white.cgColor
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 8
        shadowContainerView.layer.cornerRadius = 8
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 2
        
        sizeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 15
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        [minusButton, plusButton].forEach {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            $0.layer.borderWidth = 2.5
            $0.layer.borderColor = UIColor.blue.cgColor
            $0.setTitleColor(.blue, for: .normal)
            $0.layer.cornerRadius = 15
            $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        counterContainerView.backgroundColor = UIColor.systemGray5
        counterContainerView.layer.cornerRadius = 10
        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        counterContainerView.addSubview(counterLabel)
        
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: counterContainerView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: counterContainerView.centerYAnchor),
            counterLabel.widthAnchor.constraint(equalTo: counterContainerView.widthAnchor),
            counterLabel.heightAnchor.constraint(equalTo: counterContainerView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shadowContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shadowContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shadowContainerView.widthAnchor.constraint(equalToConstant: 90),
            shadowContainerView.heightAnchor.constraint(equalToConstant: 90),
            
            itemImageView.centerXAnchor.constraint(equalTo: shadowContainerView.centerXAnchor),
            itemImageView.centerYAnchor.constraint(equalTo: shadowContainerView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 90),
            itemImageView.heightAnchor.constraint(equalToConstant: 90),
            
            deleteButton.leadingAnchor.constraint(equalTo: shadowContainerView.leadingAnchor, constant: 5),
            deleteButton.bottomAnchor.constraint(equalTo: shadowContainerView.bottomAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            sizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            sizeLabel.leadingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor, constant: 16),
            sizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            plusButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            
            counterContainerView.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            counterContainerView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            counterContainerView.widthAnchor.constraint(equalToConstant: 35),
            counterContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            minusButton.trailingAnchor.constraint(equalTo: counterContainerView.leadingAnchor, constant: -8),
            minusButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func deleteTapped() {
        onDelete?()
    }
    
    @objc private func minusTapped() {
        guard let productId = productId, quantity > 1 else { return }
        quantity -= 1
        counterLabel.text = "\(quantity)"
        onQuantityChanged?(productId, quantity) // Передаем id товара + новое количество
    }
    
    @objc private func plusTapped() {
        guard let productId = productId else { return }
        quantity += 1
        counterLabel.text = "\(quantity)"
        onQuantityChanged?(productId, quantity) // Передаем id товара + новое количество
    }
}

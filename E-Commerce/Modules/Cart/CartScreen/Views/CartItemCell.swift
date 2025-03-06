//
//  CartItemCell.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sizeLabel = UILabel()
    private let priceLabel = UILabel()
    private let counterLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .custom)
    private let counterContainerView = UIView()
    
    var itemID: UUID?
    var onDelete: (() -> Void)?
    var onQuantityChanged: ((Int) -> Void)?
    
    private var quantity = 1 {
        didSet {
            counterLabel.text = "\(quantity)"
            onQuantityChanged?(quantity)
            updateMinusButtonState()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configure(image: UIImage?, title: String, size: String, price: Double, quantity: Int) {
        itemImageView.image = image
        titleLabel.text = title
        sizeLabel.text = "Size: \(size)"
        priceLabel.text = String(format: "$%.2f", price)
        self.quantity = quantity
        updateMinusButtonState()
    }
    
    private func setupUI() {
        [itemImageView, titleLabel, sizeLabel, priceLabel, deleteButton, minusButton, counterContainerView, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8
        itemImageView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.custom(font: .nunitoLight, size: 12)
        sizeLabel.font = UIFont.custom(font: .ralewayMedium, size: 14)
        priceLabel.font = UIFont.custom(font: .ralewayBold, size: 18)
        
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
            $0.layer.cornerRadius = 18
            $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        counterContainerView.backgroundColor = UIColor(named: "QuantityBackgroundColor")
        counterContainerView.layer.cornerRadius = 10
        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        counterContainerView.addSubview(counterLabel)
        
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.custom(font: .ralewayMedium, size: 16)
        
        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: counterContainerView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: counterContainerView.centerYAnchor),
            counterLabel.widthAnchor.constraint(equalTo: counterContainerView.widthAnchor),
            counterLabel.heightAnchor.constraint(equalTo: counterContainerView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 90),
            itemImageView.heightAnchor.constraint(equalToConstant: 90),
            
            deleteButton.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: 5),
            deleteButton.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            
            sizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            sizeLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            sizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            
            priceLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            counterContainerView.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            counterContainerView.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            counterContainerView.widthAnchor.constraint(equalToConstant: 40),
            counterContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            minusButton.trailingAnchor.constraint(equalTo: counterContainerView.leadingAnchor, constant: -8),
            minusButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor)
        ])
    }
    
    @objc private func deleteTapped() {
        onDelete?()
    }
    
    @objc private func minusTapped() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    @objc private func plusTapped() {
        quantity += 1
    }
}


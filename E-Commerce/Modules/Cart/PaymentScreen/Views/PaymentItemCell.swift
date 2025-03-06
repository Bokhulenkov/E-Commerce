//
//  CartItemCell.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit

class PaymentItemCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let counterLabel = UILabel()
    
    private let counterContainerView = UIView()
    
    var itemID: UUID?
    
    private var quantity = 1 {
        didSet {
            counterLabel.text = "\(quantity)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, title: String, price: Double, quantity: Int) {
        itemImageView.image = image
        titleLabel.text = title
        priceLabel.text = String(format: "$%.2f", price)
        self.quantity = quantity
    }
    
    private func setupUI() {
        [itemImageView, counterContainerView, titleLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // Настройка изображения
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 35
        itemImageView.layer.masksToBounds = true
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.borderColor = UIColor.white.cgColor
        
        // Настройка счётчика
        counterContainerView.backgroundColor = UIColor(named: "QuantityBackgroundColor")
        counterContainerView.layer.borderWidth = 1
        counterContainerView.layer.borderColor = UIColor.white.cgColor
        counterContainerView.clipsToBounds = true
        counterContainerView.layer.cornerRadius = 10
        counterContainerView.addSubview(counterLabel)
        
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.custom(font: .ralewayMedium, size: 13)
        
        // Настройка текста
        
        titleLabel.font = UIFont.custom(font: .nunitoLight, size: 12)
        priceLabel.font = UIFont.custom(font: .ralewayBold, size: 18)
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            // Картинка слева
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 70),
            itemImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // Счётчик (поверх картинки, в верхнем левом углу)
            counterContainerView.widthAnchor.constraint(equalToConstant: 20),
            counterContainerView.heightAnchor.constraint(equalToConstant: 20),
            counterContainerView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: -5),
            counterContainerView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 0),
            
            // Центрируем цифру внутри счётчика
            counterLabel.centerXAnchor.constraint(equalTo: counterContainerView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: counterContainerView.centerYAnchor),
            
            // Текст справа от картинки
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -12),
            
            // Цена справа
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

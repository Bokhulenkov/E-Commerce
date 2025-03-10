//
//  CartItemCell.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit
import Kingfisher


class PaymentItemCell: UITableViewCell {

    // MARK: - UI Elements

    private let itemImageView = UIImageView()
    private let shadowContainerView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let counterLabel = UILabel()
    private let counterContainerView = UIView()

    // MARK: - Properties

    private var quantity = 1 {
        didSet {
            counterLabel.text = "\(quantity)"
        }
    }

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func configure(image: String?, title: String, price: Double, quantity: Int) {
        if let imageUrl = image, let url = URL(string: imageUrl) {
            itemImageView.kf.setImage(with: url)
        }

        titleLabel.text = title
        priceLabel.text = String(format: "$%.2f", price)
        self.quantity = quantity
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(itemImageView)
        contentView.addSubview(counterContainerView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)

        // MARK: - Shadow Container Setup

        shadowContainerView.translatesAutoresizingMaskIntoConstraints = false
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainerView.layer.shadowRadius = 4

        // MARK: - Item Image Setup

        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 35
        itemImageView.layer.borderWidth = 5
        itemImageView.layer.borderColor = UIColor.white.cgColor

        // MARK: - Counter Setup

        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        counterContainerView.backgroundColor = UIColor(named: "QuantityBackgroundColor")
        counterContainerView.layer.borderWidth = 1
        counterContainerView.layer.borderColor = UIColor.white.cgColor
        counterContainerView.layer.cornerRadius = 10
        counterContainerView.clipsToBounds = true
        counterContainerView.addSubview(counterLabel)

        // MARK: - Title and Price Setup

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.custom(font: .nunitoLight, size: 12)
        titleLabel.numberOfLines = 2
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.custom(font: .ralewayBold, size: 18)

        // MARK: - Counter Label Setup

        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.custom(font: .ralewayMedium, size: 13)

        // MARK: - Layout Constraints

        NSLayoutConstraint.activate([

            shadowContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shadowContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shadowContainerView.widthAnchor.constraint(equalToConstant: 70),
            shadowContainerView.heightAnchor.constraint(equalToConstant: 70),

            itemImageView.centerXAnchor.constraint(equalTo: shadowContainerView.centerXAnchor),
            itemImageView.centerYAnchor.constraint(equalTo: shadowContainerView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 70),
            itemImageView.heightAnchor.constraint(equalToConstant: 70),

            counterContainerView.widthAnchor.constraint(equalToConstant: 20),
            counterContainerView.heightAnchor.constraint(equalToConstant: 20),
            counterContainerView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: -5),
            counterContainerView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 0),

            counterLabel.centerXAnchor.constraint(equalTo: counterContainerView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: counterContainerView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 160),

            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

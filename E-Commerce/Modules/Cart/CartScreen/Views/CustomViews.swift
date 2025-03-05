//
//  CustomViews.swift
//  E-Commerce
//
//  Created by Григорий Душин on 05.03.2025.
//

import UIKit

class AddressView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping Address"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Your address here"  // Можно обновлять через метод
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20  // круглая кнопка
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return button
    }()
    
    var onEditTapped: (() -> Void)?
    
    var currentAddress: String {
        return addressLabel.text ?? ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, addressLabel, editButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8),
            
            // Address
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8),
            addressLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            // Edit Button
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func editTapped() {
        onEditTapped?()
    }
    
    func updateAddress(_ address: String) {
        addressLabel.text = address
    }
}


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
        label.font = UIFont.custom(font: .ralewayBold, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(font: .nunitoLight, size: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let pencilImage = UIImage(systemName: "pencil")
        let config = UIImage.SymbolConfiguration(weight: .heavy) // Make the icon bolder
        button.setImage(pencilImage?.withConfiguration(config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.layer.cornerRadius = 20
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
        
        backgroundColor = UIColor(named: "SearchFieldBackGroundColor")
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
        print("Edit button tapped!")
        onEditTapped?()
    }
    
    func updateAddress(_ address: String, title: String) {
        addressLabel.text = address
        titleLabel.text = title
    }
}


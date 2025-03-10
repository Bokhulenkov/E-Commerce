//
//  SearchHistoryCell.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 10.03.2025.
//

import UIKit

final class SearchHistoryCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(font: .ralewayMedium, size: 17)
        label.textColor = .black
        return label
    }()
        
        private let closeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("✕", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return button
        }()
        
        private var onDelete: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = UIColor(named: "SearchHistoryBackgroundColor")
            contentView.layer.cornerRadius = 12
            
            let stackView = UIStackView(arrangedSubviews: [label, closeButton])
            stackView.axis = .horizontal
            stackView.spacing = 8
            
            contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
            ])
            
            closeButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(text: String, onDelete: @escaping () -> Void) {
            label.text = text
            self.onDelete = onDelete
        }
        
        @objc private func deleteTapped() {
            onDelete?()
        }
    }


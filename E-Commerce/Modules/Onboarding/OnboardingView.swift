//
//  OnboardingView.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class OnboardingView: UIView {
        
    private lazy var imageView: UIImageView = {
            let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = .custom(font: CustomFont.ralewayBlack, size: 20)
            label.textColor = .black
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.8
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .custom(font: CustomFont.nunito, size: 15)
            label.textColor = .darkGray
            label.numberOfLines = 3
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.8
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private var startButton: UIButton?
        
    init(image: UIImage?, title: String, description: String, button: UIButton? = nil) {
        self.startButton = button
            super.init(frame: .zero)
            
            setupView()
            configure(image: image, title: title, description: description)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(image: UIImage?, title: String, description: String) {
            imageView.image = image
            titleLabel.text = title
            descriptionLabel.text = description
        }
    }

private extension OnboardingView {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowColor = UIColor(named: "DeliveryAddressTextColor")?.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 7)
        layer.shadowRadius = 15
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
        
        if let button = startButton {
            addSubview(button)
            translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                button.heightAnchor.constraint(equalToConstant: 10)
            ])
        }
    }
}


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
        label.font = .custom(font: .nunito, size: 12)
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "$17,00"
        label.textAlignment = .left
        label.font = .custom(font: .ralewayBlack, size: 17)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
   
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.spacing = 18
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = .custom(font: .nunito, size: 10)
        button.layer.cornerRadius = 4
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.heartRedFull, for: .normal)
        
        return button
    }()
    
    //MARK: - Properties
    var likeButtonAction: ((Bool) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    @objc private func likeButtonTapped() {
        likeButtonAction?(likeButton.currentImage == .heartRed)
        likeButton.currentImage == .heartRedFull ? likeButton.setImage(.heartRed, for: .normal) : likeButton.setImage(.heartRedFull, for: .normal)
    }
    
    private func setupUI() {
        addSubview(shadowView)
        addSubview(photoImageView)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(cartButton)
        stackView.addArrangedSubview(likeButton)
        
        setupConstraints()
    }
    
    private func  setupConstraints() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            stackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 6),
            stackView.heightAnchor.constraint(equalToConstant: 31),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            cartButton.heightAnchor.constraint(equalToConstant: 31),

            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.widthAnchor.constraint(equalToConstant: 22),
        ])
    }
}

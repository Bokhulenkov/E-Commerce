//
//  DetailNavBarView.swift
//  E-Commerce
//
//  Created by Анна on 06.03.2025.
//

import UIKit

class DetailNavBarView: UIStackView {
    // MARK: - GUI Variables
    private let likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.heartRed, for: .normal)
        button.backgroundColor = .variationsBackground
        button.clipsToBounds = true
        button.layer.cornerRadius = 11
        
        return button
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Add to cart", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.layer.cornerRadius = 11
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveToCartAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Buy now", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.layer.cornerRadius = 11
        button.backgroundColor = .button
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buyNowAction), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Properties
    var likeButtonAction: ((Bool) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupView()
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .white
        axis = .horizontal
        spacing = 16
        distribution = .fillProportionally
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        isLayoutMarginsRelativeArrangement = true
    }
    
    @objc private func likeButtonTapped() {
        likeButtonAction?(likeButton.currentImage == .heartRed)
        likeButton.currentImage == .heartRed ? likeButton.setImage(.heartRedFull, for: .normal) : likeButton.setImage(.heartRed, for: .normal)
    }
    
    private func setupUI() {
        addArrangedSubview(likeButton)
        addArrangedSubview(addToCartButton)
        addArrangedSubview(buyButton)
        
        setupConstraints()
    }
    
    private func  setupConstraints() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 47),
            
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            
            buyButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func saveToCartAction(_ button: UIButton) {
      //save to cart
    }
    
    @objc private func buyNowAction(_ button: UIButton) {
        //redirect to checkout screen
    }
}

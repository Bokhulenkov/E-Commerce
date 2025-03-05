//
//  HomePopularViewCell.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 04.03.2025.
//

import UIKit
import Kingfisher

class HomePopularViewCell: UICollectionViewCell {
    
    private let productImageViewContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .productTest
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .nunito, size: 12)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 17)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func prepareForReuse() {
        backgroundColor = .clear
        productImageView.image = nil
        productTitle.text = nil
        productPrice.text = nil
    }
    
    private func configureCell() {
        backgroundColor = .clear
        
        addSubview(productImageViewContainer)
        productImageViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        productImageViewContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productImageViewContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productImageViewContainer.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        productImageViewContainer.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: productImageViewContainer.topAnchor, constant: 5).isActive = true
        productImageView.leftAnchor.constraint(equalTo: productImageViewContainer.leftAnchor, constant: 5).isActive = true
        productImageView.rightAnchor.constraint(equalTo: productImageViewContainer.rightAnchor, constant: -5).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: productImageViewContainer.bottomAnchor, constant: -5).isActive = true

        addSubview(productTitle)
        productTitle.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 11).isActive = true
        productTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        addSubview(productPrice)
        productPrice.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 1).isActive = true
        productPrice.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        productPrice.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        productPrice.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }
    
    public func configure(_ image: String?, _ title: String, _ price: Double) {
        productTitle.text = "\(title)"
        productPrice.text = "$\(price)"
        
        if let imageUrl = image, let url = URL(string: imageUrl) {
            productImageView.kf.setImage(with: url)
            productImageView.layer.cornerRadius = 5
        }
    }
}

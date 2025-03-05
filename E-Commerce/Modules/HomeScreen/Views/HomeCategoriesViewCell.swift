//
//  HomeCategoriesViewCell.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 04.03.2025.
//

import UIKit

class HomeCategoriesViewCell: UICollectionViewCell {
    
    private var imageViews: [UIImageView] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let countView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(red: 0.875, green: 0.914, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func prepareForReuse() {
        backgroundColor = .white
        titleLabel.text = nil
        countLabel.text = nil
    }
    
    private func configureCell() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
        
        addSubview(countView)
        countView.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
        countView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        countView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        countView.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        addSubview(countLabel)
        countLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: countView.leftAnchor, constant: -6).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        let imageSize = Int(self.frame.width - 6 - 4 - 6)/2
        for x in 0..<2 {
            for y in 0..<2 {
                let imageView = UIImageView()
                imageView.frame = CGRect(x: 6 + x*(imageSize + 5), y: 6 + y*(imageSize + 5), width: imageSize, height: imageSize)
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = 5
                imageView.clipsToBounds = true
                addSubview(imageView)
                imageViews.append(imageView)
            }
        }
    }
    
    public func configure(with category: String, count: Int, images: [UIImage?]) {
        titleLabel.text = "\(category)"
        countLabel.text = "\(count)"
        
        for i in 0..<imageViews.count {
            if let image = images[i] {
                imageViews[i].image = image
            }
        }
    }
        
}

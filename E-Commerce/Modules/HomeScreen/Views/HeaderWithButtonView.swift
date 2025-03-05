//
//  HeaderWithButtonView.swift
//  E-Commerce
//
//  Created by Александр Пеньков on 05.03.2025.
//

import UIKit

class HeaderWithButtonView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.custom(font: .ralewayBold, size: 21)
        label.textColor = .black
        return label
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.font = UIFont.custom(font: .ralewayBold, size: 15)
        label.textColor = .black
        return label
    }()

    private let viewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0, green: 0.298, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        addSubview(viewButton)
        viewButton.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        viewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
        addSubview(buttonLabel)
        buttonLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        buttonLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        buttonLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        buttonLabel.rightAnchor.constraint(equalTo: viewButton.leftAnchor, constant: -13).isActive = true
    }
    
    public func configure(_ title: String, _ buttonTitle: String, _ target: Any?, _ action: Selector) {
        titleLabel.text = title
        buttonLabel.text = buttonTitle
        viewButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

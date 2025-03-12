//
//  CustomPaymentViews.swift
//  E-Commerce
//
//  Created by Григорий Душин on 06.03.2025.
//

import UIKit

// MARK: - ShippingOptionsView

class ShippingOptionsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping Options"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let standardOptionView = ShippingOptionView(title: "Standard", deliveryTime: "5-7 days", price: "FREE")
    private let expressOptionView = ShippingOptionView(title: "Express", deliveryTime: "1-2 days", price: "$12.00")
    private let deliveryDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivered on or before Thursday, 23 April 2020"
        label.font = UIFont.custom(font: .nunitoLight, size: 13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var selectedOption: ShippingOptionView?
    var onShippingOptionChanged: ((Bool) -> Void)?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        selectOption(standardOptionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(standardOptionView)
        addSubview(expressOptionView)
        addSubview(deliveryDateLabel)

        let standardTap = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
        let expressTap = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
        standardOptionView.addGestureRecognizer(standardTap)
        expressOptionView.addGestureRecognizer(expressTap)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            standardOptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            standardOptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            standardOptionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            standardOptionView.heightAnchor.constraint(equalToConstant: 40),
            expressOptionView.topAnchor.constraint(equalTo: standardOptionView.bottomAnchor, constant: 8),
            expressOptionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            expressOptionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expressOptionView.heightAnchor.constraint(equalToConstant: 40),
            deliveryDateLabel.topAnchor.constraint(equalTo: expressOptionView.bottomAnchor, constant: 8),
            deliveryDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            deliveryDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            deliveryDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func optionTapped(_ gesture: UITapGestureRecognizer) {
        guard let selectedView = gesture.view as? ShippingOptionView else { return }
        selectOption(selectedView)
    }

    // MARK: - Private Methods

//    private func selectOption(_ option: ShippingOptionView) {
//        selectedOption?.isSelected = false
//        option.isSelected = true
//        selectedOption = option
//
//        deliveryDateLabel.text = option === expressOptionView ?
//            "Delivered on or before Monday, 13 April 2020" : "Delivered on or before Thursday, 23 April 2020"
//    }
    
    private func selectOption(_ option: ShippingOptionView) {
            selectedOption?.isSelected = false
            option.isSelected = true
            selectedOption = option

            let isExpress = option === expressOptionView
            deliveryDateLabel.text = isExpress ?
                "Delivered on or before Monday, 13 April 2020" : "Delivered on or before Thursday, 23 April 2020"

            onShippingOptionChanged?(isExpress) // Сообщаем контроллеру об изменении опции
        }

    func getSelectedOption() -> String {
        return selectedOption === standardOptionView ? "Standard" : "Express"
    }
}

// MARK: - ShippingOptionView

class ShippingOptionView: UIView {
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(font: .ralewaySemiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(font: .ralewayMedium, size: 13)
        label.textColor = .blue
        label.backgroundColor = UIColor(named: "ClosesCategoryBackgroundColor")
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.custom(font: .ralewayBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? UIColor(named: "QuantityBackgroundColor") : UIColor(named: "SearchFieldBackGroundColor")
            checkmarkImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
            checkmarkImageView.tintColor = isSelected ? .systemBlue : .gray
        }
    }

    // MARK: - Initializer

    init(title: String, deliveryTime: String, price: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        deliveryTimeLabel.text = deliveryTime
        priceLabel.text = price
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkmarkImageView)
        addSubview(titleLabel)
        addSubview(deliveryTimeLabel)
        addSubview(priceLabel)

        NSLayoutConstraint.activate([
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            deliveryTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            deliveryTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            deliveryTimeLabel.widthAnchor.constraint(equalToConstant: 80),
            deliveryTimeLabel.heightAnchor.constraint(equalToConstant: 24),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

class PatView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Method"
        label.font = UIFont.custom(font: .ralewayBold, size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let methodLabel: UILabel = {
        let label = UILabel()
        label.text = "Card"
        label.font = UIFont.custom(font: .ralewaySemiBold, size: 18)
        label.textColor = UIColor(named: "ButtonColor")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let methodContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "QuantityBackgroundColor")
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let pencilImage = UIImage(systemName: "pencil")
        let config = UIImage.SymbolConfiguration(weight: .heavy)
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
        return methodLabel.text ?? ""
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

        [titleLabel, methodContainerView, editButton].forEach { addSubview($0) }
        methodContainerView.addSubview(methodLabel)
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            // Method Container
            methodContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            methodContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            methodContainerView.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8),
            methodContainerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            // Method Label внутри контейнера
            methodLabel.topAnchor.constraint(equalTo: methodContainerView.topAnchor, constant: 6),
            methodLabel.bottomAnchor.constraint(equalTo: methodContainerView.bottomAnchor, constant: -6),
            methodLabel.leadingAnchor.constraint(equalTo: methodContainerView.leadingAnchor, constant: 16),
            methodLabel.trailingAnchor.constraint(equalTo: methodContainerView.trailingAnchor, constant: -16),

            // Edit Button
            editButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor, constant: -8)
        ])
    }
    
    @objc private func editTapped() {
        onEditTapped?()
    }
    
    func updatePaymentMethod(_ method: String) {
        methodLabel.text = method
    }
}


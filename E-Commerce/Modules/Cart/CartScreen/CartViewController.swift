//
//  CartViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cartCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressView = AddressView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120
        return tableView
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total $00.00"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var cartItems = [
        (image: UIImage(named: "placeholder"), title: "Item 1", size: "M", price: 17.00, quantity: 1),
        (image: UIImage(named: "placeholder"), title: "Item 2", size: "M", price: 17.00, quantity: 1),
        (image: UIImage(named: "placeholder"), title: "Item 3", size: "M", price: 17.00, quantity: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartCell")
        
        setupUI()
        updateCartInfo()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(cartCountLabel)
        view.addSubview(addressView)
        view.addSubview(tableView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(totalLabel)
        bottomContainerView.addSubview(checkoutButton)
        
        addressView.updateAddress("Default Test Adress Moscow, Red Squere, 1")
        
        addressView.onEditTapped = { [weak self] in
            self?.showAddressInput()
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            cartCountLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            cartCountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cartCountLabel.widthAnchor.constraint(equalToConstant: 24),
            cartCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            addressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addressView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            totalLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            totalLabel.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            
            checkoutButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),
            checkoutButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            checkoutButton.widthAnchor.constraint(equalToConstant: 120),
            checkoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateCartInfo() {
        let itemCount = cartItems.reduce(0) { $0 + $1.quantity }
        cartCountLabel.text = "\(itemCount)"
        
        let totalPrice = cartItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
        totalLabel.text = String(format: "Total $%.2f", totalPrice)
    }
    
    private func removeItem(at indexPath: IndexPath) {
        cartItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateCartInfo()
    }
    
    private func showAddressInput() {
        let alert = UIAlertController(title: "Edit Address", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter your address"
            textField.text = self.addressView.currentAddress
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let newAddress = alert.textFields?.first?.text {
                self.addressView.updateAddress(newAddress)
            }
        }
        
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartItemCell
        let item = cartItems[indexPath.row]
        cell.configure(image: item.image, title: item.title, size: item.size, price: item.price, quantity: item.quantity)
        
        cell.onDelete = { [weak self] in
            self?.removeItem(at: indexPath)
        }
        
        cell.onQuantityChanged = { [weak self] newQuantity in
            self?.cartItems[indexPath.row].quantity = newQuantity
            self?.updateCartInfo()
        }
        
        return cell
    }
}



class CartItemCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let sizeLabel = UILabel()
    private let priceLabel = UILabel()
    private let counterLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .custom)
    private let counterContainerView = UIView()

    var onDelete: (() -> Void)?
    var onQuantityChanged: ((Int) -> Void)?
    
    private var quantity = 1 {
        didSet {
            counterLabel.text = "\(quantity)"
            onQuantityChanged?(quantity)
            updateMinusButtonState()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateMinusButtonState() {
        if quantity <= 1 {
            minusButton.isEnabled = false
            minusButton.setTitleColor(.lightGray, for: .normal)
            minusButton.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            minusButton.isEnabled = true
            minusButton.setTitleColor(.blue, for: .normal)
            minusButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func configure(image: UIImage?, title: String, size: String, price: Double, quantity: Int) {
        itemImageView.image = image
        titleLabel.text = title
        sizeLabel.text = "Size: \(size)"
        priceLabel.text = String(format: "$%.2f", price)
        self.quantity = quantity
        updateMinusButtonState()
    }
    
    private func setupUI() {
        [itemImageView, titleLabel, sizeLabel, priceLabel, deleteButton, minusButton, counterContainerView, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 8
        itemImageView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        sizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 20
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        [minusButton, plusButton].forEach {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            $0.layer.borderWidth = 2.5
            $0.layer.borderColor = UIColor.blue.cgColor
            $0.setTitleColor(.blue, for: .normal)
            $0.layer.cornerRadius = 18
            $0.widthAnchor.constraint(equalToConstant: 36).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }

        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        // Настройка серого контейнера для счетчика
        counterContainerView.backgroundColor = UIColor.systemGray5
        counterContainerView.layer.cornerRadius = 10
        counterContainerView.translatesAutoresizingMaskIntoConstraints = false
        counterContainerView.addSubview(counterLabel)

        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.textAlignment = .center
        counterLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        NSLayoutConstraint.activate([
            counterLabel.centerXAnchor.constraint(equalTo: counterContainerView.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: counterContainerView.centerYAnchor),
            counterLabel.widthAnchor.constraint(equalTo: counterContainerView.widthAnchor),
            counterLabel.heightAnchor.constraint(equalTo: counterContainerView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 90),
            itemImageView.heightAnchor.constraint(equalToConstant: 90),

            deleteButton.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: -50),
            deleteButton.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),

            sizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            sizeLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            sizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),

            priceLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: plusButton.leadingAnchor, constant: -16),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),

            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            counterContainerView.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            counterContainerView.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            counterContainerView.widthAnchor.constraint(equalToConstant: 40),
            counterContainerView.heightAnchor.constraint(equalToConstant: 36),

            minusButton.trailingAnchor.constraint(equalTo: counterContainerView.leadingAnchor, constant: -8),
            minusButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor)
        ])
    }

    @objc private func deleteTapped() {
        onDelete?()
    }

    @objc private func minusTapped() {
        if quantity > 1 {
            quantity -= 1
        }
    }

    @objc private func plusTapped() {
        quantity += 1
    }
}


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

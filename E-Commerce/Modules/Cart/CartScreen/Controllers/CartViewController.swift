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
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cartCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.backgroundColor = UIColor(named: "QuantityBackgroundColor")
        label.textAlignment = .center
        label.font = UIFont.custom(font: .ralewayBold, size: 18)
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
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SearchHistoryBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total $00.00"
        label.font = UIFont.custom(font: .ralewaySemiBold, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.backgroundColor = UIColor(named: "ButtonColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var cartView = CartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none

        
        setupUI()
        updateCartInfo()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(cartCountLabel)
        view.addSubview(addressView)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(totalLabel)
        bottomContainerView.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        
        addressView.updateAddress("Default Test Address Russian Federation, Moscow, Red Square, 1", title: "Shipping Address")
        
        addressView.onEditTapped = { [weak self] in
            self?.showAddressInput()
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            cartCountLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            cartCountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cartCountLabel.widthAnchor.constraint(equalToConstant: 24),
            cartCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            addressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addressView.heightAnchor.constraint(equalToConstant: 85),
            
            tableView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
        let cartItems = cartView.getItems()
        let itemCount = cartItems.reduce(0) { $0 + $1.quantity }
        cartCountLabel.text = "\(itemCount)"
        
        let totalPrice = cartView.calculateTotal()
        totalLabel.text = String(format: "Total $%.2f", totalPrice)
        
        let isEmpty = cartItems.isEmpty
        tableView.isHidden = isEmpty
        emptyStateView.isHidden = !isEmpty
        bottomContainerView.isHidden = isEmpty
    }
    
    private func updateQuantity(for itemID: UUID, newQuantity: Int) {
        cartView.updateQuantity(for: itemID, quantity: newQuantity)
        updateCartInfo()
    }
    
    private func removeItem(at indexPath: IndexPath) {
        cartView.removeItem(at: indexPath.row)
        updateCartInfo()
        tableView.reloadData()
    }
    
    private func showAddressInput() {
        let alert = UIAlertController(title: "Edit Address", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter your address"
            textField.text = self.addressView.currentAddress
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let newAddress = alert.textFields?.first?.text {
                self.addressView.updateAddress(newAddress, title: "Shipping Address")
            }
        }
        
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func checkoutTapped() {
        proceedToPayment()
        print("checkoutTapped")
    }
    
    private func proceedToPayment() {
        let paymentVC = PaymentViewController()
        present(paymentVC, animated: true)
        print("checkoutTapped_PROCEEEEEEEEEEEEEEEED")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartView.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartItemCell
        let item = cartView.getItems()[indexPath.row]
        cell.configure(image: item.image, title: item.title, size: item.size, price: item.price, quantity: item.quantity)
        
        cell.onDelete = { [weak self] in
            self?.removeItem(at: indexPath)
        }
        
        cell.onQuantityChanged = { [weak self] newQuantity in
            self?.updateQuantity(for: item.id, newQuantity: newQuantity)
        }
        
        return cell
    }
}





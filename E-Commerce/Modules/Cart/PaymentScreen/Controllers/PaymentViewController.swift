//
//  PaymentViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment"
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Items"
        label.font = UIFont.custom(font: .ralewayBold, size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addVoucherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Voucher", for: .normal)
        button.setTitleColor(UIColor(named: "ButtonColor"), for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "ButtonColor")?.cgColor
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
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
    private let contactInfoView = AddressView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
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
        button.setTitle("Pay", for: .normal)
        button.titleLabel?.font = UIFont.custom(font: .nunitoLight, size: 16)
        button.backgroundColor = UIColor.black
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
        tableView.register(PaymentItemCell.self, forCellReuseIdentifier: "PaymentCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none

        
        setupUI()
        updateCartInfo()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(addressView)
        view.addSubview(contactInfoView)
        view.addSubview(titleLabel2)
        view.addSubview(addVoucherButton)
        view.addSubview(cartCountLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(totalLabel)
        bottomContainerView.addSubview(checkoutButton)
        
        addressView.updateAddress("Default Test Address Russian Federation, Moscow, Red Square, 1", title: "Shipping Address")
        contactInfoView.updateAddress("Default Test Info: +37469873414", title: "Contact Information")
        
        
        addressView.onEditTapped = { [weak self] in
            self?.showAddressInput()
        }
        
        contactInfoView.onEditTapped = { [weak self] in
            self?.showContactInfoInput()
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addressView.heightAnchor.constraint(equalToConstant: 85),
            
            contactInfoView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 10),
            contactInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contactInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contactInfoView.heightAnchor.constraint(equalToConstant: 85),
            
            titleLabel2.topAnchor.constraint(equalTo: contactInfoView.bottomAnchor, constant: 15),
            titleLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            addVoucherButton.centerYAnchor.constraint(equalTo: titleLabel2.centerYAnchor),
            addVoucherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cartCountLabel.leadingAnchor.constraint(equalTo: titleLabel2.trailingAnchor, constant: 8),
            cartCountLabel.centerYAnchor.constraint(equalTo: titleLabel2.centerYAnchor),
            cartCountLabel.widthAnchor.constraint(equalToConstant: 24),
            cartCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            tableView.topAnchor.constraint(equalTo: cartCountLabel.bottomAnchor, constant: 16),
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
    
    private func showContactInfoInput() {
        let alert = UIAlertController(title: "Edit Information", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter your contacts"
            textField.text = self.contactInfoView.currentAddress
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let newAddress = alert.textFields?.first?.text {
                self.contactInfoView.updateAddress(newAddress, title: "Contact Information")
            }
        }
        
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartView.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentItemCell
        let item = cartView.getItems()[indexPath.row]
        cell.configure(image: item.image, title: item.title,price: item.price, quantity: item.quantity)
        
        return cell
    }
}

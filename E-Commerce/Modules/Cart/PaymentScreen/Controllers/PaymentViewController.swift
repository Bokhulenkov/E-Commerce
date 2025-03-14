//
//  PaymentViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var cartView = CartView()
    private let addressView = AddressView()
    private let contactInfoView = AddressView()
    private let shippingOptionsView = ShippingOptionsView()
    private let paymentMethodView = PatView()
    private let currencyManager = CurrencyManager()
    private var currency: String = ""
    
    // MARK: - UI Elements
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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        return tableView
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SearchHistoryBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
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
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        currency = currencyManager.getCurrency()
        NotificationCenter.default.post(name: .currencyDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PaymentItemCell.self, forCellReuseIdentifier: "PaymentCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        setupUI()
        updateCartInfo()
        updateTableViewHeight()
        
        checkoutButton.addTarget(self, action: #selector(showSuccessAlert), for: .touchUpInside)
        addVoucherButton.addTarget(self, action: #selector(addVoucherTapped), for: .touchUpInside)
        
        shippingOptionsView.onShippingOptionChanged = { [weak self] isExpress in
            self?.updateTotalPrice(isExpress: isExpress)
        }
    }
    
    // MARK: - Private Methods
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let height = tableView.contentSize.height
        tableViewHeightConstraint?.constant = height
    }
    
    private func setupUI() {
        shippingOptionsView.configureOptions(
            standardTitle: "Standard",
            standardDelivery: "5-7 days",
            standardPrice: "FREE",
            expressTitle: "Express",
            expressDelivery: "1-2 days",
            expressPrice: "\(currency)12.00"
        )
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addSubview(bottomContainerView)
        
        scrollView.addSubview(contentView)
        
        [
            titleLabel,
            addressView,
            contactInfoView,
            titleLabel2,
            addVoucherButton,
            cartCountLabel,
            tableView,
            shippingOptionsView,
            paymentMethodView
        ].forEach {
            contentView.addSubview($0)
        }
        
        bottomContainerView.addSubview(totalLabel)
        bottomContainerView.addSubview(checkoutButton)
        
        addressView.updateAddress("Default Test Address: Montenegro, Cetinje, Petra Lubard, 3A", title: "Shipping Address")
        contactInfoView.updateAddress("Default Test Info: +37469873414", title: "Contact Information")
        
        addressView.onEditTapped = { [weak self] in
            self?.showAddressInput()
        }
        
        contactInfoView.onEditTapped = { [weak self] in
            self?.showContactInfoInput()
        }
        
        paymentMethodView.onEditTapped = { [weak self] in
            self?.showPaymentMethodSelection()
        }
        
        NSLayoutConstraint.activate([
            // MARK: - ScrollView and ContentView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // MARK: - Title Labels Constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            addressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            addressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressView.heightAnchor.constraint(equalToConstant: 85),
            
            contactInfoView.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 10),
            contactInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactInfoView.heightAnchor.constraint(equalToConstant: 85),
            
            titleLabel2.topAnchor.constraint(equalTo: contactInfoView.bottomAnchor, constant: 15),
            titleLabel2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            addVoucherButton.centerYAnchor.constraint(equalTo: titleLabel2.centerYAnchor),
            addVoucherButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cartCountLabel.leadingAnchor.constraint(equalTo: titleLabel2.trailingAnchor, constant: 8),
            cartCountLabel.centerYAnchor.constraint(equalTo: titleLabel2.centerYAnchor),
            cartCountLabel.widthAnchor.constraint(equalToConstant: 24),
            cartCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // MARK: - TableView Constraints
            tableView.topAnchor.constraint(equalTo: cartCountLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // MARK: - Shipping Options & Payment Method Constraints
            shippingOptionsView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            shippingOptionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            shippingOptionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            paymentMethodView.topAnchor.constraint(equalTo: shippingOptionsView.bottomAnchor, constant: 20),
            paymentMethodView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            paymentMethodView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            paymentMethodView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // MARK: - Bottom Container View Constraints
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
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    // MARK: - Action Methods
    private func dismissAndReturnToCart() {
        dismiss(animated: true, completion: nil)
        cartView.removeAll()
    }
    
    @objc private func addVoucherTapped() {
        let alert = UIAlertController(title: "Sorry", message: "You don`t have any avaliable vouchers.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func showSuccessAlert() {
        let alert = UIAlertController(title: "Done!", message: "Your card has been successfully charged", preferredStyle: .alert)
        
        let trackOrderAction = UIAlertAction(title: "Track My Order", style: .default) { _ in
            self.dismissAndReturnToCart()
        }
        
        alert.addAction(trackOrderAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateCartInfo() {
        
        let cartCount = cartView.calculateCartCount()
        cartCountLabel.text = "\(cartCount)"
        
        let totalPrice = cartView.calculateTotal()
        totalLabel.text = String(format: "Total \(currency)%.2f", totalPrice)
        
        
    }
    
    @objc private func currencyDidChange() {
        currency = currencyManager.getCurrency()
        updateCartInfo()
        
        shippingOptionsView.configureOptions(
            standardTitle: "Standard",
            standardDelivery: "5-7 days",
            standardPrice: "FREE",
            expressTitle: "Express",
            expressDelivery: "1-2 days",
            expressPrice: "\(currency)12.00"
        )
        
        tableView.reloadData()
    }
    
    private func updateTotalPrice(isExpress: Bool) {
        let finalTotal = isExpress ? cartView.calculateTotal() + 12.00 : cartView.calculateTotal()
        totalLabel.text = String(format: "Total \(currency)%.2f", finalTotal)
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
    
    private func showPaymentMethodSelection() {
        
        let alert = UIAlertController(title: "Select Payment Method", message: nil, preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Card", style: .default) { [weak self] _ in
            self?.paymentMethodView.updatePaymentMethod("Card")
        }
        
        let applePayAction = UIAlertAction(title: "Apple Pay", style: .default) { [weak self] _ in
            self?.paymentMethodView.updatePaymentMethod("Apple Pay")
        }
        
        alert.addAction(cardAction)
        alert.addAction(applePayAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - TableView Methods
extension PaymentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartView.getItems().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentItemCell
        let item = cartView.getItems()[indexPath.row]
        print(cartView.getItems()[indexPath.row].title)
        cell.configure(
            image: item.image,
            title: item.title,
            price: String(format: "\(currency)%.2f", item.price),
            quantity: item.cartCount
        )
        
        return cell
    }
}

extension PaymentViewController: UITableViewDelegate {
    // Implement delegate methods if needed
}

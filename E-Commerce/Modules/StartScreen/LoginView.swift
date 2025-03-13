//
//  LoginView.swift
//  E-Commerce
//
//  Created by Александр Слыховский on 10.03.2025.
//

import UIKit

class LoginView: UIView {
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubbles08")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = .custom(font: .ralewayBold, size: 52)
        label.textColor = UIColor(named: "TextColor")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Good to see you back!"
        lable.font = .custom(font: .nunito, size: 19)
        lable.textColor = UIColor(named: "TextColor")
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var heartView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heartBlack")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backgoundEmailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AuthorizationFieldBackgroundColor")
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .clear
        textField.textColor = UIColor(named: "TextColor")
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var backgoundPasswordView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AuthorizationFieldBackgroundColor")
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .clear
        textField.textColor = UIColor(named: "TextColor")
        textField.borderStyle = .none
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = false
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let toggleButton = UIButton(type: .custom)
        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        toggleButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        textField.rightView = toggleButton
        textField.rightViewMode = .always
        
        return textField
    }()
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle() // Переключаем режим ввода
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye" // Меняем иконку
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(named: "ButtonColor") ?? .white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 22)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 15)
        button.setTitleColor(UIColor (named: "TextColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        backgroundColor = UIColor(named: "BackgoundColor")
        addSubview(bubbleImageView)
        addSubview(loginLabel)
        addSubview(textLabel)
        addSubview(heartView)
        addSubview(backgoundEmailView)
        addSubview(emailTextField)
        addSubview(backgoundPasswordView)
        addSubview(passwordTextField)
        addSubview(nextButton)
        addSubview(cancelButton)
    }
    
    internal func setupButtons(target: Any?, actionNextButton: Selector, actionCancelButton: Selector){
        nextButton.addTarget(target, action: actionNextButton, for: .touchUpInside)
        cancelButton.addTarget(target, action: actionCancelButton, for: .touchUpInside)
    }
    
    
}



//MARK: Extensions

extension LoginView {
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            
            bubbleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bubbleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bubbleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bubbleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            
            loginLabel.topAnchor.constraint(equalTo: topAnchor, constant: 428),
            loginLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            
            textLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            heartView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            heartView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 10),
            
            
            backgoundEmailView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 17),
            backgoundEmailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgoundEmailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgoundEmailView.heightAnchor.constraint(equalToConstant: 60),
            
            
            emailTextField.topAnchor.constraint(equalTo: backgoundEmailView.topAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: backgoundEmailView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: backgoundEmailView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 20),
            
            
            backgoundPasswordView.topAnchor.constraint(equalTo: backgoundEmailView.bottomAnchor, constant: 15),
            backgoundPasswordView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgoundPasswordView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgoundPasswordView.heightAnchor.constraint(equalToConstant: 60),
            
            
            passwordTextField.topAnchor.constraint(equalTo: backgoundPasswordView.topAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: backgoundPasswordView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: backgoundPasswordView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 20),
            
            
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -117),
            nextButton.heightAnchor.constraint(equalToConstant: 61),
            
            
            cancelButton.centerXAnchor.constraint(equalTo:  centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 27),
            
        ])
    }
}







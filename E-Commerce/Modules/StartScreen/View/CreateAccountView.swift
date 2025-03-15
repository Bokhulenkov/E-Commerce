//
//  CreateAccountView.swift
//  E-Commerce
//
//  Created by Александр Слыховский on 10.03.2025.
//

import UIKit

class CreateAccountView: UIView {
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubbles07")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var createLabel: UILabel = {
        let label = UILabel()
        label.text = "Create"
        label.font = .custom(font: .ralewayBold, size: 52)
        label.textColor = UIColor(named: "TextColor")
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accountLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Account"
        lable.font = .custom(font: .ralewayBold, size: 52)
        lable.textColor = UIColor(named: "TextColor")
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
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
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
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
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setViews() {
        backgroundColor = UIColor(named: "BackgoundColor")
        addSubview(bubbleImageView)
        addSubview(createLabel)
        addSubview(accountLabel)
        addSubview(backgoundEmailView)
        addSubview(emailTextField)
        addSubview(backgoundPasswordView)
        addSubview(passwordTextField)
        addSubview(doneButton)
        addSubview(cancelButton)
    }
    
    func setupButtons(target: Any?, actionDoneButton: Selector, actionCancelButton: Selector){
        doneButton.addTarget(target, action: actionDoneButton, for: .touchUpInside)
        cancelButton.addTarget(target, action: actionCancelButton, for: .touchUpInside)
    }
    
    public func getUserEmailPass() -> (email: String?, password: String?){
        return (emailTextField.text, passwordTextField.text)
    }
    
    // MARK: - Actions
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle() // Переключаем режим ввода
        
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye" // Меняем иконку
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}



//MARK: Extensions

extension CreateAccountView {
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            //Bubble View:
            bubbleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bubbleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bubbleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            
            //Create Label:
            createLabel.topAnchor.constraint(equalTo: topAnchor, constant: 110),
            createLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            //Account Label:
            accountLabel.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 0),
            accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            //Backgound Email background:
            backgoundEmailView.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 250),
            backgoundEmailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgoundEmailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgoundEmailView.heightAnchor.constraint(equalToConstant: 60),
            
            //Email field:
            emailTextField.topAnchor.constraint(equalTo: backgoundEmailView.topAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: backgoundEmailView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: backgoundEmailView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 20),
            
            //Backgound Password background:
            backgoundPasswordView.topAnchor.constraint(equalTo: backgoundEmailView.bottomAnchor, constant: 15),
            backgoundPasswordView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgoundPasswordView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgoundPasswordView.heightAnchor.constraint(equalToConstant: 60),
            
            //Password field:
            passwordTextField.topAnchor.constraint(equalTo: backgoundPasswordView.topAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: backgoundPasswordView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: backgoundPasswordView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 20),
            
            //Done button:
            doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -117),
            doneButton.heightAnchor.constraint(equalToConstant: 61),
            
            //Cancel button:
            cancelButton.centerXAnchor.constraint(equalTo:  centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 27),
        ])
    }
}

// MARK: - Extensions UITextFieldDelegate

extension CreateAccountView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
}

//
//  SettingsViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private var userID: String? = nil
    private let settingsTitle: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayBold, size: 28)
        label.textColor = .text
        label.textAlignment = .left
        return label
    }()
    
    private let settingsDescription: UILabel = {
        let label = UILabel()
        label.text = "Your Profile"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.custom(font: .ralewayMedium, size: 16)
        label.textColor = .text
        label.textAlignment = .left
        return label
    }()
    
    private let avatarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 52
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.image = .productTest
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 46
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let changeAvatarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.changeButton, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .settingsTextFieldBackground
        textField.layer.cornerRadius = 9
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .settingsTextFieldBackground
        textField.layer.cornerRadius = 9
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private let passTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .settingsTextFieldBackground
        textField.layer.cornerRadius = 9
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.layer.cornerRadius = 9
        button.backgroundColor = UIColor(red: 0, green: 0.29, blue: 1, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passTextField.delegate = self
        
        saveButton.addTarget(self, action: #selector(saveChangesButtonAction(_:)), for: .touchUpInside)
        changeAvatarButton.addTarget(self, action: #selector(changeAvatarButtonAction(_:)), for: .touchUpInside)
        
        FirebaseService.shared.signIn() { result in
            switch result {
            case .success(let user):
                self.userID = user.uid
                FirebaseService.shared.getUserData(userId: user.uid) { result in
                    switch result {
                    case .success(let data):
                        self.setupData(userData: data)
                    case .failure(let error):
                        print("Ошибка получения даных: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Ошибка авторизации: \(error.localizedDescription)")
            }
        }
    }

    private func configureUI() {
        view.addSubview(settingsTitle)
        settingsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        settingsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        settingsTitle.heightAnchor.constraint(equalToConstant: 36).isActive = true
        settingsTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(settingsDescription)
        settingsDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        settingsDescription.topAnchor.constraint(equalTo: settingsTitle.bottomAnchor, constant: 7).isActive = true
        settingsDescription.heightAnchor.constraint(equalToConstant: 36).isActive = true
        settingsDescription.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(avatarBackgroundView)
        avatarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        avatarBackgroundView.topAnchor.constraint(equalTo: settingsDescription.bottomAnchor, constant: 18).isActive = true
        avatarBackgroundView.heightAnchor.constraint(equalToConstant: 104).isActive = true
        avatarBackgroundView.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        view.addSubview(avatarImageView)
        avatarImageView.centerXAnchor.constraint(equalTo: avatarBackgroundView.centerXAnchor, constant: 0).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: avatarBackgroundView.centerYAnchor, constant: 0).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 92).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 92).isActive = true
        
        view.addSubview(changeAvatarButton)
        changeAvatarButton.topAnchor.constraint(equalTo: avatarBackgroundView.topAnchor, constant: 0).isActive = true
        changeAvatarButton.rightAnchor.constraint(equalTo: avatarBackgroundView.rightAnchor, constant: 0).isActive = true
        changeAvatarButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        changeAvatarButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: avatarBackgroundView.bottomAnchor, constant: 20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(passTextField)
        passTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        passTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(saveButton)
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //MARK: Func
    
    private func setupData(userData: [String: Any]) {
        nameTextField.text = userData["name"] as? String
        emailTextField.text = userData["email"] as? String
        passTextField.text = userData["password"] as? String
    }
    
    //MARK: Action
    
    @objc func saveChangesButtonAction(_ button: UIButton) {
        guard let userID = self.userID else { return }
        FirebaseService.shared.saveUserData(userId: userID, userData: ["name": "\(nameTextField.text ?? "")",
                                                                       "email": "\(emailTextField.text ?? "")",
                                                                       "password": "\(passTextField.text ?? "")"]) { result in
            switch result {
            case .success():
                print("Данные успешно сохранены")
            case .failure(let error):
                print("Ошибка сохранения: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func changeAvatarButtonAction(_ button: UIButton) {
        print("changeAvatarButtonAction")
    }
}

//MARK: UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        textField.resignFirstResponder()
        return true
    }
}

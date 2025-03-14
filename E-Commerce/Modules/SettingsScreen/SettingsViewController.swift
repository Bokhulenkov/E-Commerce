//
//  SettingsViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private var currentName: String = ""
    private var currentEmail: String = ""
    private var currentPass: String = ""

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
        view.image = nil
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
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.layer.cornerRadius = 9
        button.backgroundColor = UIColor.systemRed
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
        signOutButton.addTarget(self, action: #selector(signOutButtonAction(_:)), for: .touchUpInside)

        FirebaseService.shared.getCurrentUser() { result in
            if let user = result {
                let uid = user.uid
                self.currentEmail = user.email ?? ""
                self.currentName = user.displayName ?? ""
                self.setupData(userData: ["name": "\(self.currentName)", "email": "\(self.currentEmail)", "password": ""])
            }
        }
        
        loadAvatar()
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
        
        view.addSubview(signOutButton)
        signOutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signOutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(saveButton)
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: signOutButton.topAnchor, constant: -10).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //MARK: Func
    
    private func setupData(userData: [String: Any]) {
        nameTextField.text = userData["name"] as? String
        emailTextField.text = userData["email"] as? String
        passTextField.text = userData["password"] as? String
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.firstMatch(of: emailRegex) != nil
    }
    
    private func showEmailErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Введет некорректный email", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showPassErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Пароль должен быть длиннее 6 символов", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showSucessSaveAlert() {
        let alert = UIAlertController(title: "Данные успешно обновлены", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(_ text: String) {
        let alert = UIAlertController(title: "\(text)", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func saveAvatar(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.75) {
            let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            if let documentDirectory = urls.first {
                let fileURL = documentDirectory.appendingPathComponent("avatar.jpg")
                do {
                    try data.write(to: fileURL)
                    print("Аватар успешно сохранён")
                } catch {
                    print("Ошибка сохранения аватара: \(error)")
                }
            }
        }
    }
    
    private func loadAvatar() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentDirectory = urls.first {
            let fileURL = documentDirectory.appendingPathComponent("avatar.jpg")
            if let imageData = try? Data(contentsOf: fileURL), let image = UIImage(data: imageData) {
                avatarImageView.image = image
            }
        }
    }
    
    //MARK: Action
    
    @objc func saveChangesButtonAction(_ button: UIButton) {
        if currentName != nameTextField.text ?? "" {
            FirebaseService.shared.updateDisplayName(newName: "\(nameTextField.text ?? "")") { error in
                if let error = error {
                    print("Ошибка при обновлении имени: \(error.localizedDescription)")
                    self.showAlert(error.localizedDescription)
                } else {
                    print("Имя пользователя успешно обновлено!")
                }
            }
        }
        
        if currentPass != passTextField.text ?? "" && (passTextField.text ?? "").count >= 6 {
            FirebaseService.shared.updatePassword(newPassword: "\(passTextField.text ?? "")") { error in
                if let error = error {
                    print("Ошибка при обновлении пароля: \(error.localizedDescription)")
                    self.showAlert(error.localizedDescription)
                } else {
                    print("Пароль успешно изменён!")
                }
            }
        } else if currentPass != passTextField.text ?? "" {
            if (passTextField.text ?? "").count < 6 {
                showPassErrorAlert()
            }
        }
        
        if currentEmail != emailTextField.text ?? "" && isValidEmail(emailTextField.text ?? "") == true {
            FirebaseService.shared.updateEmail(newEmail: "\(emailTextField.text ?? "")") { error in
                if let error = error {
                    print("Ошибка при обновлении email: \(error.localizedDescription)")
                    self.showAlert(error.localizedDescription)
                } else {
                    print("Email успешно изменён!")
                }
            }
        } else if currentEmail != emailTextField.text ?? "" && isValidEmail(emailTextField.text ?? "") == false {
            showEmailErrorAlert()
        }
    }
    
    @objc func changeAvatarButtonAction(_ button: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func signOutButtonAction(_ button: UIButton) {
        FirebaseService.shared.signOut { error in
            if let error = error {
                print("Ошибка выхода: \(error.localizedDescription)")
                self.showAlert(error.localizedDescription)
            } else {
                print("Выход выполнен успешно")
                
                let vc = LoginViewController()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                    
                UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window?.rootViewController = vc
                })
            }
        }

    }
}

//MARK: UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        avatarImageView.image = selectedImage
        saveAvatar(image: selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

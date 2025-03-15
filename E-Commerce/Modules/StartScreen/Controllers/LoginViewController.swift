//
//  LoginViewController.swift
//  E-Commerce
//
//  Created by Александр Слыховский on 10.03.2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    //    MARK: - Properties
    
    private let loginView = LoginView()
    
    
    //    MARK: - LifeCycle
    override func loadView() {
        view = loginView
        loginView.setupButtons(target: self,
                               actionNextButton:  #selector(nextButtonTapped),
                               actionCancelButton:  #selector(cancelButtonTapped))
    }
    
    @objc private func nextButtonTapped() {
        print("Кнопка Next нажата!")
        
        let userData = loginView.getUserEmailPass()
        if userData.email != nil && userData.password != nil {
            FirebaseService.shared.authUser(email: userData.email!, password: userData.password!) {  result in
                switch result {
                case .success(let user):
                    print("user: \(user.uid)")
                    self.setNextController()
                case .failure(let error):
                    print("Ошибка авторизации: \(error.localizedDescription)")
                    self.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        print("Кнопка Cancel нажата!")
        let vc = StartScreenViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func showErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setNextController() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHidding()
    }
}

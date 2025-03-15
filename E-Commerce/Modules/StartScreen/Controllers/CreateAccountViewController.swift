//
//  CreateAccountViewController.swift
//  E-Commerce
//
//  Created by Александр Слыховский on 10.03.2025.
//

import UIKit

final class CreateAccountViewController: UIViewController {
    
    //    MARK: - Properties
    
    private let createAccountView = CreateAccountView()
    
    //    MARK: - LifeCycle
    
    override func loadView() {
        view = createAccountView
        createAccountView.setupButtons(
            target: self,
            actionDoneButton:  #selector(doneButtonTapped),
            actionCancelButton:  #selector(cancelButtonTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHidding()
    }
    
    // MARK: - Methods
    
    private func showErrorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setOnboarding() {
        let vc = OnboardingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        print("Кнопка Done нажата!")
        let userData = createAccountView.getUserEmailPass()
        
        if userData.email != nil && userData.password != nil {
            FirebaseService.shared.createUser(email: userData.email!, password: userData.password!) {  result in
                switch result {
                case .success(let user):
                    print("user: \(user.uid)")
                    self.setOnboarding()
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
}

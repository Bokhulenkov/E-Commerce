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
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonTapped() {
        print("Кнопка Cancel нажата!")
        let vc = StartScreenViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

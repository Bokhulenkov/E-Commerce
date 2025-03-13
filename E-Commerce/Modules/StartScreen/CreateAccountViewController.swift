//
//  CreateAccountViewController.swift
//  E-Commerce
//
//  Created by Александр Слыховский on 10.03.2025.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //    MARK: - Properties
    
    private let createAccountView = CreateAccountView()
    
    
    //    MARK: - LifeCycle
    override func loadView() {
        view = createAccountView
        createAccountView.setupButtons(target: self,
                                       actionDoneButton:  #selector(doneButtonTapped),
                                       actionCancelButton:  #selector(cancelButtonTapped))
    }
    
    @objc private func doneButtonTapped() {
        print("Кнопка Done нажата!")
        let vc = OnboardingViewController()
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

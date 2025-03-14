//
//  StartScreenViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class StartScreenViewController: UIViewController {
    
    
    
    //    MARK: - Properties
    
    private let startScreenView = StartScreenView()
    
    
    //    MARK: - LifeCycle
    override func loadView() {
        view = startScreenView
        startScreenView.setupButtons(target: self,
                                     actionStartButton:  #selector(startButtonTapped),
                                     actionArrowButton:  #selector(arrowButtonTapped))
    }
    
    @objc private func startButtonTapped() {
        //print("Кнопка Старт нажата!")
        let vc = CreateAccountViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func arrowButtonTapped() {
        //print("Кнопка Со стрелкой нажата!")
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

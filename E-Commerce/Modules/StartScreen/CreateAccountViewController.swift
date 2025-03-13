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
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}

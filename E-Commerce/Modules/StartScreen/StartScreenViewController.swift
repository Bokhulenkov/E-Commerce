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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
    }
    
}

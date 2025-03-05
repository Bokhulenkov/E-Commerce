//
//  OnboardingViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    //MARK: UIElements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BubblesBG")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = currentPage
        pageControl.pageIndicatorTintColor = UIColor(named: "ItemsBackgroundColor")
        pageControl.currentPageIndicatorTintColor = UIColor(named: "ButtonColor")
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("Start", for: .normal)
        startButton.tintColor = UIColor(named: "ButtonColor")
        startButton.isHidden = true
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        return startButton
    }()
    
    private lazy var view1 = OnboardingView(image: UIImage(named: "product01"), title: "Welcome!", description: "Discover a fast and easy way to shop online.")
    private lazy var view2 = OnboardingView(image: UIImage(named: "product02"), title: "Smart Search & Favorites", description: "Find products instantly and save favorites for later.")
    private lazy var view3 = OnboardingView(image: UIImage(named: "men"), title: "Easy Checkout", description: "Add to cart, choose payment, and order in seconds.")
    private lazy var view4 = OnboardingView(image: UIImage(named: "electr"), title: "Manage Your Store", description: "Become a manager, add products, and control your catalog!", button: startButton)
    
    private var currentPage = 0
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

//MARK: private methods

private extension OnboardingViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(startButton)
        view.addSubview(pageControl)
        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(view4)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let views = [view1, view2, view3, view4]
            views.forEach { view in
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    view.widthAnchor.constraint(equalToConstant: 300),
                    view.heightAnchor.constraint(equalToConstant: 500)
                ])
                view.isHidden = true
            }
            
            view1.isHidden = false
            
            NSLayoutConstraint.activate([
                startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                startButton.heightAnchor.constraint(equalToConstant: 50),
    
                pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              
            ])
    }
    
    @objc func startPressed() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

#Preview { OnboardingViewController() }

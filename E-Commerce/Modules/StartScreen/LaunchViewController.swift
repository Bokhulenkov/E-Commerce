//
//  LaunchViewController.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 14.03.2025.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LaunchViewController: UIViewController {
    
    //Создаем Image View (белый круг с тенью):
    private lazy var circleWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        view.layer.cornerRadius = 67
        view.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        view.layer.shadowOpacity = 0.2                 // Прозрачность тени (0.0 - 1.0)
        view.layer.shadowOffset = CGSize(width: 4, height: 4) // Смещение тени
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Создаем Image View (картинка сумки):
    private lazy var bagPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bag")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Создаем лейбл
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shoppe" // Текст лейбла
        label.font = UIFont(name: "Raleway-v4020-Bold", size: 52) // Имя и размер шрифта
        label.textColor = .black // Цвет текста
        label.textAlignment = .center // Выравнивание по центру
        label.translatesAutoresizingMaskIntoConstraints = false // Включаем Auto Layout
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        checkUserAuthentication()
    }
    
    private func checkUserAuthentication() {
        FirebaseService.shared.getCurrentUser { user in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if user != nil {
                    self.showTabBar()
                } else {
                    self.showAuthScreen()
                }
            }
        }
    }
    
    private func showTabBar() {
        let tabBarVC = TabBarViewController()
        tabBarVC.modalTransitionStyle = .flipHorizontal
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true, completion: nil)
    }
    
    private func showAuthScreen() {
        let authVC = StartScreenViewController()
        authVC.modalTransitionStyle = .crossDissolve
        authVC.modalPresentationStyle = .fullScreen
        self.present(authVC, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgoundColor") //Задаем цвет из Ассетов.
        view.addSubview(titleLabel) //Добавляем сабвью для лейбла
        view.addSubview(circleWhiteView) //Добавляем сабвью для круга
        view.addSubview(bagPicture) //Добавляем сабвью для сумки
        
        NSLayoutConstraint.activate([
            //Image View:
            circleWhiteView.topAnchor.constraint(equalTo: view.topAnchor, constant: 232),
            circleWhiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleWhiteView.widthAnchor.constraint(equalToConstant: 134),
            circleWhiteView.heightAnchor.constraint(equalToConstant: 134),
            
            //Bag Picture:
            bagPicture.leadingAnchor.constraint(equalTo: circleWhiteView.leadingAnchor, constant: 26),
            bagPicture.trailingAnchor.constraint(equalTo: circleWhiteView.trailingAnchor, constant: -26),
            bagPicture.topAnchor.constraint(equalTo: circleWhiteView.topAnchor, constant: 21),
            bagPicture.bottomAnchor.constraint(equalTo: circleWhiteView.bottomAnchor, constant: -21),
            
            //Title Lable:
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: circleWhiteView.bottomAnchor, constant: 24)
        ])
    }
}

//#Preview { LaunchViewController() }

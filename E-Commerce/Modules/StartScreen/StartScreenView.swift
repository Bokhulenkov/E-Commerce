//
//  StartScreenView.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

class StartScreenView: UIView {
    
    //Создаем Image View (белый круг с тенью):
    private lazy var circleWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        view.layer.cornerRadius = 67
        view.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        view.layer.shadowOpacity = 0.2                 // Прозрачность тени (0.0 - 1.0)
        view.layer.shadowOffset = CGSize(width: 4, height: 4) // Смещение тени
        view.layer.shadowRadius = 5                    // Радиус размытия тени
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
    
    //Создаем кнопку
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Let's get started", for: .normal) // Устанавливаем текст кнопки
        button.backgroundColor = UIColor(named: "ButtonColor") ?? .white // Устанавливаем цвет фона
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let customFont = UIFont(name: "NunitoSans-Regular", size: 22) {
            button.titleLabel?.font = customFont // Применяем кастомный шрифт
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
            // Если шрифт не найден, используем системный
        }
        return button
    }()
    
    // Создаем лейбл нижний
    private lazy var titleLabelAccount: UILabel = {
        let label = UILabel()
        label.text = "I already have an account"
        label.font = .custom(font: .nunito, size: 15)
        label.textColor = UIColor(hex: "202020")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //Создаем кнопку со стрелкой
    private lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "button"), for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //Инициализатор:
    override init(frame: CGRect) {
        super.init(frame: frame) //Передает размеры в родительский класс UIView.
        setViews() //Задаем основные свойства вью.
        setupConstraints() //Устанавливаем констреинты.
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //Инициализатор, запрещающий сториборды.
    }
    
    //Настраиваем Вью:
    func setViews() {
        backgroundColor = UIColor(named: "BackgoundColor") //Задаем цвет из Ассетов.
        addSubview(titleLabel) //Добавляем сабвью для лейбла
        addSubview(circleWhiteView) //Добавляем сабвью для круга
        addSubview(bagPicture) //Добавляем сабвью для сумки
        addSubview(startButton)
        addSubview(titleLabelAccount)
        addSubview(arrowButton)
    }
    
    
    internal func setupButtons(target: Any?, actionStartButton: Selector, actionArrowButton: Selector){
        //print("setupButtons сработала")
        startButton.addTarget(target, action: actionStartButton, for: .touchUpInside)
        arrowButton.addTarget(target, action: actionArrowButton, for: .touchUpInside)
    }
    
    
}




//MARK: Extensions

extension StartScreenView {
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            //Image View:
            circleWhiteView.topAnchor.constraint(equalTo: topAnchor, constant: 232),
            circleWhiteView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleWhiteView.widthAnchor.constraint(equalToConstant: 134),
            circleWhiteView.heightAnchor.constraint(equalToConstant: 134),
            
            //Bag Picture:
            bagPicture.leadingAnchor.constraint(equalTo: circleWhiteView.leadingAnchor, constant: 26),
            bagPicture.trailingAnchor.constraint(equalTo: circleWhiteView.trailingAnchor, constant: -26),
            bagPicture.topAnchor.constraint(equalTo: circleWhiteView.topAnchor, constant: 21),
            bagPicture.bottomAnchor.constraint(equalTo: circleWhiteView.bottomAnchor, constant: -21),
            
            //Title Lable:
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: circleWhiteView.bottomAnchor, constant: 24),
            
            //Start Button:
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -117),
            startButton.heightAnchor.constraint(equalToConstant: 61),
            
            //Title Lable Account:
            titleLabelAccount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 81),
            titleLabelAccount.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 27),
            
            //Arrow Button:
            arrowButton.leadingAnchor.constraint(equalTo: titleLabelAccount.trailingAnchor, constant: 16),
            arrowButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 24),
            
        ])
    }
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

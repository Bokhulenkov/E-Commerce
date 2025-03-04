
//
//  HeaderView.swift
//  E-Commerce
//
//  Created by Anna Melekhina on 04.03.2025.
//

import UIKit

protocol HeaderDelegate {
    func callHeader(idx: Int)
}

class HeaderView: UIView {
    
    var secIndex: Int?
    var delegate: HeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var btn: UIButton = {
        let btn = UIButton(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = false
        btn.clipsToBounds = false
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btn.layer.shadowRadius = 4
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(onClickHeaderView), for: .touchUpInside)
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "sample")
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.layer.cornerRadius = 5
        leftImageView.clipsToBounds = true
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(systemName: "chevron.up")
        rightImageView.tintColor = .blue
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addSubview(leftImageView)
        btn.addSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 10),
            leftImageView.topAnchor.constraint(equalTo: btn.topAnchor, constant: 10),
            leftImageView.widthAnchor.constraint(equalToConstant: 39),
            leftImageView.heightAnchor.constraint(equalToConstant: 39),
            
            rightImageView.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -10),
            rightImageView.centerYAnchor.constraint(equalTo: btn.centerYAnchor)
        ])
        
        return btn
    }()
    
    @objc func onClickHeaderView() {
        if let idx = secIndex {
            delegate?.callHeader(idx: idx)
        }
    }
}

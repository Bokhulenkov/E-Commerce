//
//  HomeViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    private let headerCategoriesView = HeaderWithButtonView()
    lazy var collectionCategoriesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HomeCategoriesViewCell.self, forCellWithReuseIdentifier: "HomeCategoriesViewCell")
        return collectionView
    }()
    
    private let headerPopularView = HeaderWithButtonView()
    lazy var collectionPopularView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.register(HomePopularViewCell.self, forCellWithReuseIdentifier: "HomePopularViewCell")
        return collectionView
    }()
    
    private let headerProductsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Just For You"
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .black
        return label
    }()
    lazy var collectionProductsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 13
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(HomeProductViewCell.self, forCellWithReuseIdentifier: "HomeProductViewCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        scrollView.addSubview(headerCategoriesView)
        headerCategoriesView.configure("Categories", "See All", self, #selector(openCategoriesButtonAction))
        headerCategoriesView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        headerCategoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerCategoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true

        scrollView.addSubview(collectionCategoriesView)
        collectionCategoriesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        collectionCategoriesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        collectionCategoriesView.topAnchor.constraint(equalTo: headerCategoriesView.bottomAnchor, constant: 10).isActive = true
        collectionCategoriesView.heightAnchor.constraint(equalTo: collectionCategoriesView.widthAnchor, multiplier: 1.8).isActive = true
        
        scrollView.addSubview(headerPopularView)
        headerPopularView.configure("Popular", "See All", self, #selector(openPopularButtonAction))
        headerPopularView.topAnchor.constraint(equalTo: collectionCategoriesView.bottomAnchor, constant: 22).isActive = true
        headerPopularView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerPopularView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        
        scrollView.addSubview(collectionPopularView)
        collectionPopularView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionPopularView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionPopularView.topAnchor.constraint(equalTo: headerPopularView.bottomAnchor, constant: 24).isActive = true
        collectionPopularView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollView.addSubview(headerProductsLabel)
        headerProductsLabel.topAnchor.constraint(equalTo: collectionPopularView.bottomAnchor, constant: 22).isActive = true
        headerProductsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        headerProductsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        
        scrollView.addSubview(collectionProductsView)
        collectionProductsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 21).isActive = true
        collectionProductsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21).isActive = true
        collectionProductsView.topAnchor.constraint(equalTo: headerProductsLabel.bottomAnchor, constant: 10).isActive = true
        collectionProductsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        collectionProductsView.heightAnchor.constraint(equalTo: collectionProductsView.widthAnchor, multiplier: 1.8).isActive = true
    }
    
    //MARK: Action
    
    @objc func openCategoriesButtonAction(_ button: UIButton) {
        print("openCategoriesButtonAction")
    }
    
    @objc func openPopularButtonAction(_ button: UIButton) {
        print("openPopularButtonAction")
    }
}

//MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {

}

//MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionCategoriesView {
            return 6
        } else if collectionView == collectionPopularView {
            return 10
        } else if collectionView == collectionProductsView {
            return 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionCategoriesView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoriesViewCell", for: indexPath) as! HomeCategoriesViewCell
            cell.configure(with: "Watch", count: 288, images: [.F_2_E_8_E_4_C_3_E_5_F_7_45_BC_9_DFD_34_A_479_B_8_D_2_B_7, .F_2_E_8_E_4_C_3_E_5_F_7_45_BC_9_DFD_34_A_479_B_8_D_2_B_7, .F_2_E_8_E_4_C_3_E_5_F_7_45_BC_9_DFD_34_A_479_B_8_D_2_B_7 ,.F_2_E_8_E_4_C_3_E_5_F_7_45_BC_9_DFD_34_A_479_B_8_D_2_B_7])
            return cell
            
        } else if collectionView == collectionPopularView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePopularViewCell", for: indexPath) as! HomePopularViewCell
            return cell
            
        } else if collectionView == collectionProductsView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductViewCell", for: indexPath) as! HomeProductViewCell
            return cell

        } else {
            
            return UICollectionViewCell()
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionCategoriesView {
            
            let width = (collectionCategoriesView.frame.width - 4) / 2
            let height = width + 30
            return CGSize(width: width, height: height)
            
        } else if collectionView == collectionPopularView {
            
            return CGSize(width: 140, height: 204)

        } else if collectionView == collectionProductsView {
            
            let width = (collectionProductsView.frame.width - 13) / 2
            let height = width * 1.75
            return CGSize(width: width, height: height)

        } else {
            
            return CGSize(width: 0, height: 0)
        }
    }
}

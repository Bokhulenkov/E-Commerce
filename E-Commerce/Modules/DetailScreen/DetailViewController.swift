//
//  DetailViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        return view
    }()
    
    private let contentView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "chevron.backward")
        
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.9)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "datailPhotoImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = "$17,00"
        label.textAlignment = .left
        label.font = UIFont.custom(font: .ralewayBlack, size: 26)
        
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.heartRed, for: .normal)
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.custom(font: .nunito, size: 15)
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam arcu mauris, scelerisque eu mauris id, pretium pulvinar sapien."
        
        return label
    }()
    
    private lazy var variationsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Variations"
        label.font = UIFont.custom(font: .ralewayBlack, size: 20)
        
        return label
    }()
    
    private lazy var firstVariationLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Pink"
        label.backgroundColor = .variationsBackground
        label.font = UIFont.custom(font: .ralewayMedium, size: 14)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var secondVariationLabel: UILabel = {
        let label = UILabel()
        
        label.text = "M"
        label.backgroundColor = .variationsBackground
        label.font = UIFont.custom(font: .ralewayMedium, size: 14)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailViewCell.self, forCellWithReuseIdentifier: "DetailViewCell")
        
        return collectionView
    }()
    
    private lazy var detailNavBar: DetailNavBarView = {
        let view = DetailNavBarView()
        
        return view
    }()
    
    //MARK: - Properties
    var likeButtonAction: ((Bool) -> Void)?
    var networkService = NetworkService()
    var product: ProductModel?
    var images: [String] = []
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        networkService.delegate = self
        networkService.performRequest()
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    //MARK: - Methods
    func configure(for product: ProductRealmModel) {
        descriptionLabel.text = "\(product.specification)"
        priceLabel.text = "\(product.price)"
        firstVariationLabel.text = "\(product.category)"
        secondVariationLabel.text = "\(product.rate)"
        images = (1...3).map { "\(product.id).\($0)" }

        if let url = URL(string: product.image) {
            mainImageView.kf.setImage(with: url)
            mainImageView.layer.cornerRadius = 5
        }
        
        collectionView.reloadData()
    }
    
    //MARK: - Private methods
    @objc private func likeButtonTapped() {
        likeButtonAction?(likeButton.currentImage == .heartRed)
        likeButton.currentImage == .heartRed ? likeButton.setImage(.heartRedFull, for: .normal) : likeButton.setImage(.heartRed, for: .normal)
    }
    
    @objc private func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(variationsLabel)
        contentView.addSubview(firstVariationLabel)
        contentView.addSubview(secondVariationLabel)
        contentView.addSubview(collectionView)
        view.addSubview(detailNavBar)
        
        view.bringSubviewToFront(backButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        variationsLabel.translatesAutoresizingMaskIntoConstraints = false
        firstVariationLabel.translatesAutoresizingMaskIntoConstraints = false
        secondVariationLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        detailNavBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 18),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            likeButton.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 25),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            likeButton.widthAnchor.constraint(equalToConstant: 22),
            likeButton.heightAnchor.constraint(equalToConstant: 21),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 14),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            variationsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            variationsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            variationsLabel.trailingAnchor.constraint(equalTo: firstVariationLabel.leadingAnchor, constant: -9),
            
            firstVariationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 19),
            firstVariationLabel.trailingAnchor.constraint(equalTo: secondVariationLabel.leadingAnchor, constant: -6),
            
            firstVariationLabel.widthAnchor.constraint(equalToConstant: 125),
            firstVariationLabel.heightAnchor.constraint(equalToConstant: 25),
            
            secondVariationLabel.widthAnchor.constraint(equalToConstant: 54),
            secondVariationLabel.heightAnchor.constraint(equalToConstant: 25),
            secondVariationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 19),
            
            collectionView.topAnchor.constraint(equalTo: variationsLabel.bottomAnchor, constant: 13),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -84),
            collectionView.heightAnchor.constraint(equalToConstant: 75),
            
            detailNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailNavBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailNavBar.heightAnchor.constraint(equalToConstant: 84)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailViewCell", for: indexPath) as! DetailViewCell
        
        cell.configure(for: images[indexPath.row])
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    
}

//MARK: -  UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}

//MARK: - NetworkServiceDelegate
extension DetailViewController: NetworkServiceDelegate {
    func didUpdateData(products: [ProductModel]) {
        
    }
    
    func didFailWithError(error: any Error) {
        print("didFailWithError: \(error)")
    }
}

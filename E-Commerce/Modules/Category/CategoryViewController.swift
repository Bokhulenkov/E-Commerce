//
//  CategoryViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private lazy var tblView = UITableView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "All categories"
        label.font =  .custom(font: CustomFont.ralewayBold, size: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var data = categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tblView.delegate = self
        tblView.dataSource = self
        setupTableView()
        
    }
}

private extension CategoryViewController {
    func setupTableView() {
        view.addSubview(tblView)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tblView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            tblView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupUI(){
        view.backgroundColor = .white
      
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tblView.frame.size.width, height: 55))
        headerView.secIndex = section
        headerView.delegate = self
        headerView.titleLabel.text = data[section].headerName
        headerView.leftImageView.image = UIImage(named: data[section].image)
        headerView.toggleChevron(isExpandable: data[section].isExpandable)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[section].isExpandable {
            return data[section].subType.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = data[indexPath.section].subType[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = data[indexPath.section].headerName
        
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            let products = tabBarController.allProducts
            var productsCategorised:[ProductRealmModel] = []
            
            switch title {
            case "Men":
                productsCategorised = products.filter { $0.category == "men's clothing" }
            case "Women":
                productsCategorised = products.filter { $0.category == "women's clothing" }
            case "Electronics":
                productsCategorised = products.filter { $0.category == "electronics" }
            case "Jewelry":
                productsCategorised = products.filter { $0.category == "jewelery" }
            default:
                print("no category")
            }
            
            let vc = ShopViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.products = productsCategorised
            vc.currency = tabBarController.currency
            present(vc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoryViewController: HeaderDelegate {
    
    func callHeader(idx: Int) {
        data[idx].isExpandable.toggle()
        tblView.reloadSections ([idx], with: .automatic)
    }
}

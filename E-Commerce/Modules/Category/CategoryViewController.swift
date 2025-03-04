//
//  CategoryViewController.swift
//  E-Commerce
//
//  Created by Alexander Bokhulenkov on 03.03.2025.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private lazy var tblView = UITableView()
    
    var data = categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        setupTableView()
        setupUI()
    }
    
}

private extension CategoryViewController {
    func setupTableView() {
        view.addSubview(tblView)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tblView.separatorStyle = .none
        
        
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tblView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupUI(){
        view.backgroundColor = .white
        title = "All categories"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: tblView.frame.size.width, height: 55))
        headerView.secIndex = section
        headerView.delegate = self
        headerView.btn.setTitle(data[section].headerName, for: .normal)
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
}

extension CategoryViewController: HeaderDelegate {
    
    func callHeader(idx: Int) {
        data[idx].isExpandable.toggle()
        tblView.reloadSections ([idx], with: .automatic)
    }
}

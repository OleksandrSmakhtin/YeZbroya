//
//  TechniqueVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 16.04.2023.
//

import UIKit

class TechniqueVC: UIViewController {
    
    //MARK: - Data
    private let categories = Category.shared.getTeqCategories()
    
    
    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let teqTable: UITableView = {
        let table = UITableView()
        table.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 15
        table.backgroundColor = UIColor(named: "tableColor")
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure nav bar
        configureNavBar()
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyTableDelegates()
    }
      
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgImageView.frame = view.frame
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubview(bgImageView)
        view.addSubview(topSeparatorView)
        view.addSubview(teqTable)
    }
    
    //MARK: - Apply constraints
    private func applyConstraints() {
        // topSeparatorView constraints
        let topSeparatorViewConstraints = [
            topSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        // teqTable constraints
        let teqTableConstraints = [
            teqTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            teqTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            teqTable.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 20),
            teqTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(teqTableConstraints)
        
    }
    
    //MARK: - Congifure nav bar
    private func configureNavBar() {
        let titleLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "єТехніка"
            lbl.textColor = .label
            lbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            return lbl
        }()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLbl)
        if #available(iOS 26.0, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }

}

//MARK: - Lifecycle
extension TechniqueVC {
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - UITableViewDelegate & DataSource
extension TechniqueVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        teqTable.delegate = self
        teqTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier) as? ListCell else { return UITableViewCell() }
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    // height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = categories[indexPath.row]
        let subcategory = DataManager.shared.getSubcategory(by: model)

        let vc = SubcategoryVC()
        vc.subcategory = subcategory
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Техніка", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

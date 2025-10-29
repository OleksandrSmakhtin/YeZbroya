//
//  GunVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 16.04.2023.
//

import UIKit

class GunVC: UIViewController {
    
    //MARK: - Data
    let categories = Category.shared.getGunCategories()

    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gunsTable: UITableView = {
        let table = UITableView()
        table.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor(named: "tableColor")//UIColor(named: "tableColor")
        table.layer.cornerRadius = 15
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
        // bg color
        view.backgroundColor = .systemBackground
        // configure nav bar
        configureNavBar()
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyTableDelegates()
        tabBarController?.tabBar.backgroundColor = .clear//UIColor(named: "tableColor")//UIColor(named: "tableColor")
//        let json = DataPersistance.shared.encodeData()
//        FileHandler.shared.saveJson(json: json)
        
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
        view.addSubview(gunsTable)

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
        
        // gunsTable constraints
        let gunsTableConstraints = [
            gunsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gunsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gunsTable.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 20),
            gunsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(gunsTableConstraints)
    }
    
    
    
    //MARK: - Congifure nav bar
    private func configureNavBar() {
        let titleLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "єЗброя"
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
extension GunVC {
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}


//MARK: - UITableViewDelegate & DataSource
extension GunVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        gunsTable.delegate = self
        gunsTable.dataSource = self
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
        let element = DataManager.shared.getElements(by: model)
        
        let vc = ElementVC()
        vc.element = element
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Зброя", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

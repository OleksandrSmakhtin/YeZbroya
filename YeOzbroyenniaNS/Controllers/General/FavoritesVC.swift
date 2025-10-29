//
//  FavoritesVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 20.04.2023.
//

import UIKit

class FavoritesVC: UIViewController {
    
    //MARK: - Data
    private var favorites = [String]()

    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let listTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(named: "tableColor")
        table.register(ListCellWithPhoto.self, forCellReuseIdentifier: ListCellWithPhoto.identifier)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 15
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let isEmptyLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Схоже, що у вас поки що немає обраних"
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
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
        view.addSubview(isEmptyLbl)
        view.addSubview(topSeparatorView)
        view.addSubview(listTable)
    }
    
    //MARK: - Apply constraints
    private func applyConstraints() {
        // topSeparatorView constraints
        let topSeparatorViewConstraints = [
            topSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSeparatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        // isEmptyLbl constraints
        let isEmptyLblConstraints = [
            isEmptyLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isEmptyLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            isEmptyLbl.widthAnchor.constraint(equalToConstant: 250)
        ]
        
        // listTable constraints
        let listTableConstraints = [
            listTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            listTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            listTable.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 20),
            listTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(isEmptyLblConstraints)
        NSLayoutConstraint.activate(listTableConstraints)
    }
    
    //MARK: - Configure nav bar
    private func configureNavBar() {
        title = "Обрані"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editAction))
    }
    
    @objc private func editAction() {
        guard !favorites.isEmpty else { return }
        
        if listTable.isEditing {
            listTable.isEditing = false
            
            listTable.reloadData()
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editAction))
        } else {
            listTable.isEditing = true
            
            listTable.reloadData()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(editAction))
        }
    }
}

//MARK: - Lifecycle
extension FavoritesVC {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        favorites = CoreDataManager.shared.fetchItems()
        print(favorites)
        DispatchQueue.main.async {
            self.listTable.reloadData()
        }
        
        if favorites.isEmpty {
            isEmptyLbl.isHidden = false
        } else {
            isEmptyLbl.isHidden = true
        }
    }
}


//MARK: - UITableViewDelegate & DataSource
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        listTable.delegate = self
        listTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellWithPhoto.identifier) as? ListCellWithPhoto else { return UITableViewCell() }
        cell.configure(with: favorites[indexPath.row], image: nil)
        return cell
    }
    
    // height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemTitle = favorites[indexPath.row]
        let item = DataManager.shared.getItem(by: itemTitle)
        let vc = ItemVC()
        //vc.item = item
        vc.configureVc(with: item, imagePath: nil)
        navigationController?.pushViewController(vc, animated: true)
    }

    // trailing swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            // delete item from data
            let item = self.favorites[indexPath.row]
            CoreDataManager.shared.deleteItem(with: item)
            self.favorites = CoreDataManager.shared.fetchItems()
            
            // delete row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // show emtyLbl if needed
            if self.favorites.isEmpty {
                self.isEmptyLbl.isHidden = false
                self.listTable.isEditing = false
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(self.editAction))
            }
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
        
    }
}

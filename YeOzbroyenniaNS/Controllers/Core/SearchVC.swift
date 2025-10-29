//
//  SearchVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 17.04.2023.
//

import UIKit

class SearchVC: UIViewController {
    
    //MARK: - Data
    private var searchedItems = DataManager.shared.getRandom()
    
    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(ListCellWithPhoto.self, forCellReuseIdentifier: ListCellWithPhoto.identifier)
        table.showsVerticalScrollIndicator = false
        table.layer.cornerRadius = 15
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.backgroundColor = UIColor(named: "tableColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Я шукаю..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.setValue("Назад", forKey: "cancelButtonText")
        return controller
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
        applySearchDelegates()
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
        view.addSubview(searchTable)
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
        
        // searchTable constraints
        let searchTableConstraints = [
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTable.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 20),
            searchTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(searchTableConstraints)
    }
    
    //MARK: - Congifure nav bar
    private func configureNavBar() {
        let titleLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "Пошук"
            lbl.textColor = .label
            lbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            return lbl
        }()
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLbl)
        if #available(iOS 26.0, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }

}

//MARK: - Lifecycle
extension SearchVC {
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - UITableViewDelegate & DataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedItems.count
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellWithPhoto.identifier) as? ListCellWithPhoto else { return UITableViewCell() }
        cell.configure(with: searchedItems[indexPath.row], image: nil)
        return cell
    }
    
    // height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let itemTitle = searchedItems[indexPath.row]
        let item = DataManager.shared.getItem(by: itemTitle)
        let vc = ItemVC()
        vc.item = item
        vc.configureVc(with: item, imagePath: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Пошук", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating {
    private func applySearchDelegates() {
        searchController.searchResultsUpdater = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 1 else { return }
        guard let resultController = searchController.searchResultsController as? SearchResultsVC else { return }
        resultController.delegate = self
        
        let searchedData = DataManager.shared.getSearchedItems(by: query)
        
        resultController.searchedData = searchedData
        
        searchedItems = searchedData
        searchTable.reloadData()
    }
}

//MARK: - SearchResultsDelegate
extension SearchVC: SearchResultDelegate {
    func didSelectItem(with title: String) {
        DispatchQueue.main.async { [weak self] in
            let item = DataManager.shared.getItem(by: title)
            let vc = ItemVC()
            vc.configureVc(with: item, imagePath: nil)
            self?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Пошук", style: .plain, target: nil, action: nil)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

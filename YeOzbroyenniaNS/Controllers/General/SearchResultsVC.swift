//
//  SearchResultsVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 20.04.2023.
//

import UIKit

protocol SearchResultDelegate: AnyObject {
    func didSelectItem(with title: String)
}

class SearchResultsVC: UIViewController {
    
    //MARK: - Delegate
    weak var delegate: SearchResultDelegate?
    
    //MARK: - Data
    public var searchedData = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }

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
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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

}


//MARK: - UITableViewDelegate & DataSource
extension SearchResultsVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedData.count
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCellWithPhoto.identifier) as? ListCellWithPhoto else { return UITableViewCell() }
        cell.configure(with: searchedData[indexPath.row], image: nil)
        return cell
    }
    
    // height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(with: searchedData[indexPath.row])
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let itemTitle = searchedData[indexPath.row]
//        let item = DataManager.shared.getItem(by: itemTitle)
//        let vc = ItemVC()
//        vc.item = item
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Пошук", style: .plain, target: nil, action: nil)
//        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  ItemVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import UIKit

class ItemVC: UIViewController {
    
    //MARK: - Data
    public var item = Item(item: "", property: [Property]())
    
    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let circleContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.layer.cornerRadius = 5
        table.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lightBg")
        return imageView
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // bg color
        view.backgroundColor = .systemBackground
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyTableDelegates()
        // set title
        itemTitle.text = item.item
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
        view.addSubview(circleContentView)
        view.addSubview(itemTitle)
        circleContentView.addSubview(itemTable)
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
        
        // circleContentView constraints
        let circleContentViewConstraints = [
            circleContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            circleContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            circleContentView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 100),
            circleContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        // itemTitle constraints
        let itemTitleConstraints = [
            itemTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemTitle.bottomAnchor.constraint(equalTo: circleContentView.topAnchor, constant: -20)
        ]
        
        // itemTable constraints
        let itemTableConstraints = [
            itemTable.leadingAnchor.constraint(equalTo: circleContentView.leadingAnchor, constant: 10),
            itemTable.trailingAnchor.constraint(equalTo: circleContentView.trailingAnchor, constant: -10),
            itemTable.topAnchor.constraint(equalTo: circleContentView.topAnchor, constant: 10),
            itemTable.bottomAnchor.constraint(equalTo: circleContentView.bottomAnchor)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(circleContentViewConstraints)
        NSLayoutConstraint.activate(itemTitleConstraints)
        NSLayoutConstraint.activate(itemTableConstraints)
    }

}


//MARK: - UITableViewDelegate & DataSource
extension ItemVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        itemTable.delegate = self
        itemTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.property.count
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier) as? ItemCell else { return UITableViewCell() }
        let properties = item.property
        
        
        cell.configure(with: properties[indexPath.row].name, value: properties[indexPath.row].value)
//        cell.textLabel?.text = properties[indexPath.row].name
//        print("\(properties[indexPath.row].name) ---- \(properties[indexPath.row].value)")
//        cell.detailTextLabel?.text = properties[indexPath.row].value
        
        return cell
    }
}

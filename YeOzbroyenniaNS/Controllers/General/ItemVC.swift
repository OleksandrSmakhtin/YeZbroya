//
//  ItemVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import UIKit
import SDWebImage

class ItemVC: UIViewController {
    
    //MARK: - Tracker
    private var isItemExists: Bool?
    
    //MARK: - Data
    public var item = Item(item: "", images: [], property: [Property]())
    public var imagePath: String?
        
    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(named: "tableColor")
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
    
    private var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor(named: "tableColor")
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(ItemPhotoCell.self, forCellWithReuseIdentifier: "ItemPhotoCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageIndicatorView: UIPageControl = {
        let view = UIPageControl()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailedPhotoView: DetailedPhotoView = {
        let view = DetailedPhotoView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // check item
        isItemExists = CoreDataManager.shared.isItemExists(with: item.item)
        // configure nav bar
        configureNavBar()
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyTableDelegates()
        applyCollectionDelegates()
        applyDetaildeViewDelegate()
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
        view.addSubview(itemTitle)
        view.addSubview(underlineView)
        view.addSubview(photoCollectionView)
        view.addSubview(pageIndicatorView)
        view.addSubview(circleContentView)
        view.addSubview(itemTable)
        view.addSubview(detailedPhotoView)
        
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
        
        
        // itemTitle constraints
        let itemTitleConstraints = [
            itemTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemTitle.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 10)
        ]
        
        // underlineView constraints
        let underlineViewConstraints = [
            underlineView.heightAnchor.constraint(equalToConstant: 1),
            underlineView.topAnchor.constraint(equalTo: itemTitle.bottomAnchor, constant: 15),
            underlineView.widthAnchor.constraint(equalToConstant: 100),
            underlineView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        
        // circleContentView constraints
        let circleContentViewConstraints = [
            circleContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            circleContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            circleContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            circleContentView.topAnchor.constraint(equalTo: pageIndicatorView.bottomAnchor, constant: 20)
        ]

        
        // itemTable constraints
        let itemTableConstraints = [
            itemTable.leadingAnchor.constraint(equalTo: circleContentView.leadingAnchor, constant: 16),
            itemTable.trailingAnchor.constraint(equalTo: circleContentView.trailingAnchor, constant: -16),
            itemTable.topAnchor.constraint(equalTo: circleContentView.topAnchor, constant: 16),
            itemTable.bottomAnchor.constraint(equalTo: circleContentView.bottomAnchor)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(itemTitleConstraints)
        NSLayoutConstraint.activate(underlineViewConstraints)
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 20),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            pageIndicatorView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            pageIndicatorView.centerXAnchor.constraint(equalTo: photoCollectionView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailedPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            detailedPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailedPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailedPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate(circleContentViewConstraints)
        NSLayoutConstraint.activate(itemTableConstraints)
        
        
        
//        if let image = imagePath {
//            itemImageView.image = UIImage(named: image)
//            NSLayoutConstraint.activate([
//            itemImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            itemImageView.heightAnchor.constraint(equalToConstant: 150),
//            itemImageView.widthAnchor.constraint(equalToConstant: 150),
//            itemImageView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 20),
//            ])
//        }
//        NSLayoutConstraint.activate(circleContentViewConstraints)
//        if let image = imagePath {
//            NSLayoutConstraint.activate([
//            circleContentView.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 20)
//            ])
//        } else {
//            NSLayoutConstraint.activate([
//            circleContentView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 60)
//            ])
//        }
        //NSLayoutConstraint.activate(itemTableConstraints)
    }
    
    
    public func configureVc(with item: Item, imagePath: String?) {
        self.item = item
        self.imagePath = imagePath
        self.pageIndicatorView.numberOfPages = item.images!.count
        self.pageIndicatorView.currentPage = 0
//        if let image = imagePath {
//            view.addSubview(itemImageView)
//        }
        //applyConstraints()
    }
    
    //MARK: - Configure nav bar
    private func configureNavBar() {
        if isItemExists! {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), style: .plain, target: self, action: #selector(addOrDeleteFavoritesAction))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)), style: .plain, target: self, action: #selector(addOrDeleteFavoritesAction))
        }
    }
    
    //MARK: - Action
    @objc private func addOrDeleteFavoritesAction() {
        
        let itemActualStatus = CoreDataManager.shared.isItemExists(with: item.item)
        
        if itemActualStatus {
            print("Item exists. Deleting...")
            CoreDataManager.shared.deleteItem(with: item.item)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        } else {
            print("Item does not exist. Saving...")
            CoreDataManager.shared.addItem(with: item.item)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))
        }
    }

}

//MARK: - Lifecycle
extension ItemVC {
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        isItemExists = CoreDataManager.shared.isItemExists(with: item.item)
        print("Item exists?: \(isItemExists)")
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
        return cell
    }
}



extension ItemVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // delegates
    private func applyCollectionDelegates() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    // number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.images!.count
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPhotoCell", for: indexPath) as! ItemPhotoCell
        cell.configure(with: item.images![indexPath.item])
        return cell
    }
    
    // did select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
//            self?.detailedPhotoView.isHidden = false
//            self?.detailedPhotoView.alpha = 1
//        }
        
        detailedPhotoView.isHidden = false
        detailedPhotoView.alpha = 1
        
        //detailedPhotoView.isHidden = false
        detailedPhotoView.configure(with: item.images![indexPath.row])
        navigationController?.isNavigationBarHidden = true
        
    }
    
    // flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
//        pageIndicatorView.currentPage = Int(pageIndex)
        guard scrollView.frame.width > 0 else { return }
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageIndicatorView.currentPage = Int(pageIndex)
    }

        
}


extension ItemVC: DetailedPhotoViewDelegate {
    private func applyDetaildeViewDelegate() {
        detailedPhotoView.delegate = self
    }
    
    func closeView() {
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
//            self?.detailedPhotoView.alpha = 0
//        } completion: { [weak self] _ in
//            self?.navigationController?.isNavigationBarHidden = false
//            self?.detailedPhotoView.isHidden = true
//        }
        detailedPhotoView.alpha = 0
        navigationController?.isNavigationBarHidden = false
        detailedPhotoView.isHidden = true
    }
}

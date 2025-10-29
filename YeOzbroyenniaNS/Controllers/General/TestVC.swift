//
//  TestVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 28/09/2025.
//

import UIKit

class TestVC: UIViewController {
    
    public var item = Item(item: "", images: [], property: [Property]())
    public var imagePath: String?
    
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    let images: [String] = ["https://readingandwrighting.wordpress.com/wp-content/uploads/2021/01/bmw_x4_1.jpg?w=640", "https://www.lockheedmartin.com/content/dam/lockheed-martin/aero/photo/f16/F-21HR-Multirole-1920.jpg.pc-adaptive.full.medium.jpg", "https://www.lockheedmartin.com/content/dam/lockheed-martin/aero/photo/f16/F-21HR-Multirole-1920.jpg.pc-adaptive.full.medium.jpg"]
    
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        detailedPhotoView.delegate = self
        bgImageView.frame = view.frame
        addSuviews()
    }

    
    private func addSuviews() {
        view.addSubview(bgImageView)
        view.addSubview(photoCollectionView)
        view.addSubview(pageIndicatorView)
        view.addSubview(detailedPhotoView)
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            pageIndicatorView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 20),
            pageIndicatorView.centerXAnchor.constraint(equalTo: photoCollectionView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailedPhotoView.topAnchor.constraint(equalTo: view.topAnchor),
            detailedPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailedPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailedPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public func configureVc(with item: Item, imagePath: String?) {
        self.item = item
        self.imagePath = imagePath
        self.pageIndicatorView.numberOfPages = item.images!.count
        self.pageIndicatorView.currentPage = 0
//        if let image = imagePath {
//            view.addSubview(itemImageView)
//        }
        
        print(item.images)
        
        applyConstraints()
    }
    
}

extension TestVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            self?.detailedPhotoView.isHidden = false
            self?.detailedPhotoView.alpha = 1
        }
        
        //detailedPhotoView.isHidden = false
        detailedPhotoView.configure(with: item.images![indexPath.row])
        navigationController?.isNavigationBarHidden = true
        
    }
    
    // flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageIndicatorView.currentPage = Int(pageIndex)
    }

        
}


extension TestVC: DetailedPhotoViewDelegate {
    func closeView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            self?.detailedPhotoView.alpha = 0
        } completion: { [weak self] _ in
            self?.navigationController?.isNavigationBarHidden = false
            self?.detailedPhotoView.isHidden = true
        }
    }
}

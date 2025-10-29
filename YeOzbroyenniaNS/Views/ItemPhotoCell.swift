//
//  ItemPhotoCell.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 28/09/2025.
//

import UIKit
import SDWebImage

class ItemPhotoCell: UICollectionViewCell {
    
    //MARK: - Identifier
    static let identifier = "ItemPhotoCell"
    
    
    private let itemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "tableColor")
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.white.withAlphaComponent(0.5).cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        //gradientLayer.frame = bounds
        return gradientLayer
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // bg color
        backgroundColor = .clear
        layer.cornerRadius = 15
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // start animations
        startShimmer()
        
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        contentView.addSubview(itemImage)
        contentView.addSubview(placeholderImage)
    }
    
    //MARK: - Apply Constraints
    private func applyConstraints() {
        
        
        NSLayoutConstraint.activate([
            itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            itemImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImage.leadingAnchor.constraint(equalTo: itemImage.leadingAnchor),
            placeholderImage.trailingAnchor.constraint(equalTo: itemImage.trailingAnchor),
            placeholderImage.topAnchor.constraint(equalTo: itemImage.topAnchor),
            placeholderImage.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor)
        ])
    }
    
    
    //MARK: - Shimmer animation
    private func startShimmer() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.clear.cgColor,
//                                UIColor.white.withAlphaComponent(0.5).cgColor,
//                                UIColor.clear.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.frame = bounds
        gradientLayer.frame = bounds
        placeholderImage.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 1.0
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    
    //MARK: - Configure with image
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        itemImage.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed) { [weak self] _,_,_,_ in
            self?.gradientLayer.removeAllAnimations()
            self?.gradientLayer.removeFromSuperlayer()
            self?.placeholderImage.removeFromSuperview()
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

//
//  ListCell.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import UIKit
import SDWebImage

enum ItemImageType {
    case png
    case other
}

class ListCellWithPhoto: UITableViewCell {

    //MARK: - Identifier
    static let identifier = "ListCellWithPhoto"
    
    //MARK: - UI Objects
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        //lbl.font = UIFont.systemFont(ofSize: lbl.font.pointSize, weight: .medium)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let zbroyaImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let disclousereIndicator: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(named: "arrow", in: nil, with: UIImage.SymbolConfiguration(pointSize: 4, weight: .medium))
        image = image?.withTintColor(.label, renderingMode: .automatic)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "separator")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // bg color
        backgroundColor = .clear
        // selection
        selectionStyle = .none
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
    }
    
    //MARK: - Required init
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        //contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(disclousereIndicator)
        contentView.addSubview(zbroyaImage)
    }
    
    //MARK: - Apply constraints
    private func applyConstraints() {
        // titleLbl constraints
        let titleLblConstraints = [
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 120),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        //image
        let zbroyaImageConstraints = [
            zbroyaImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            zbroyaImage.trailingAnchor.constraint(equalTo: titleLbl.leadingAnchor, constant: -20),
            zbroyaImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            zbroyaImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        
        // disclousere Indicator constraints
        let disclousereIndicatorConstraints = [
            disclousereIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            disclousereIndicator.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
            disclousereIndicator.heightAnchor.constraint(equalToConstant: 10),
            disclousereIndicator.widthAnchor.constraint(equalToConstant: 10)
        ]
        
        // activate constraints
        //NSLayoutConstraint.activate(bottomSeparatorViewConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(disclousereIndicatorConstraints)
        NSLayoutConstraint.activate(zbroyaImageConstraints)
    }

    //MARK: - Configure
    public func configure(with title: String, image: String?) {
        titleLbl.text = title
        
        if let image = image {
            zbroyaImage.image = UIImage(named: image)
        } else {
            let item = DataManager.shared.getItem(by: title)
            guard let imageUrlString = item.images?.first else { return }
            guard let url = URL(string: imageUrlString) else { return }
            zbroyaImage.sd_setImage(with: url)
            
        }
        
    }
    
}

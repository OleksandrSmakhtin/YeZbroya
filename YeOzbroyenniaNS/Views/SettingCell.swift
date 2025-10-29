//
//  SettingCell.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 20.04.2023.
//

import UIKit
import SDWebImage

class SettingCell: UITableViewCell {

    //MARK: - Identifier
    static let identifier = "SettingCell"
    
    //MARK: - UI Objects
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let disclousereIndicator: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(named: "arrow", in: nil, with: UIImage.SymbolConfiguration(pointSize: 4))
        image = image?.withTintColor(.label, renderingMode: .automatic)
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1
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
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(disclousereIndicator)
        contentView.addSubview(separatorView)
    }
    
    //MARK: - Apply constraints
    private func applyConstraints() {
        
        // title image view constraints
        let titleImageViewConstraints = [
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        // title lbl constraints
        let titleLblConstraints = [
            titleLbl.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 10),
            titleLbl.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor)
        ]
        
        // disclousere Indicator constraints
        let disclousereIndicatorConstraints = [
            disclousereIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            disclousereIndicator.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
            disclousereIndicator.heightAnchor.constraint(equalToConstant: 10),
            disclousereIndicator.widthAnchor.constraint(equalToConstant: 10)
        ]
        
        let separatorViewConstraints = [
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(titleImageViewConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(disclousereIndicatorConstraints)
        NSLayoutConstraint.activate(separatorViewConstraints)
    }

    //MARK: - Configure
    public func configure(with setting: Setting) {
        titleLbl.text = setting.title
        titleImageView.image = UIImage(systemName: setting.image)
        
        if setting.type == .cache {
            SDImageCache.shared.calculateSize { [weak self] fileCount, totalSize in
                self?.titleLbl.text = setting.title + ": \(totalSize / 1024 / 1024) МБ"
            }
        }
    }

}

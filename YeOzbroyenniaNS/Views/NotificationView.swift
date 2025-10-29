//
//  NorificationView.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 29/10/2025.
//

import UIKit

class NotificationView: UIView {

    //MARK: - UI Objects
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.circle")
        view.tintColor = .systemGreen
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let notificationLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .label
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // settings
        backgroundColor = UIColor(named: "tableColor")
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 4, height: 4)
//        layer.shadowRadius = 4
        layer.cornerRadius = 30
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        // add subviews
        setViews()
        // apply constraints
        setLayout()
        
    }

    //MARK: - Add subviews
    private func setViews() {
        addSubview(iconImageView)
        addSubview(notificationLbl)
    }
    
    //MARK: - Apply constraints
    private func setLayout() {
        
        let iconImageViewConstraints = [
            //iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        let achivmentLblConstraints = [
            notificationLbl.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -7),
            notificationLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notificationLbl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(achivmentLblConstraints)
    }
    
    //MARK: - Set notification
    func configure(with text: String) {
        notificationLbl.text = text
//        achivmentLbl.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
//        UIView.animate(withDuration: 0.3) { [self] in
//            achivmentLbl.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
//        }
    }
    
    //MARK: - Required init
    required init?(coder: NSCoder) {
        fatalError()
    }

}

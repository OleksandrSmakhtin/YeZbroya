//
//  SettingsVC.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 16.04.2023.
//

import UIKit
import SDWebImage
import StoreKit

class SettingsVC: UIViewController {
    
    //MARK: - Data
    private let settings = SettingsData.shared.getSettings()
    
    //MARK: - UI Objects
    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let settingsTable: UITableView = {
        let table = UITableView()
        table.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        table.layer.cornerRadius = 15
        //table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.separatorStyle = .none
        table.backgroundColor = UIColor(named: "tableColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private let notificationView: NotificationView = {
        let view = NotificationView()
        return view
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // configute nav bar
        configureNavBar()
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // apply delegates
        applyTableDelegates()
        
    }
    
    //MARK: - viewDidLayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgImageView.frame = view.frame
    }
    
    //MARK: - Add subviews
    private func addSubviews() {
        view.addSubview(bgImageView)
        view.addSubview(topSeparatorView)
        view.addSubview(settingsTable)
        view.addSubview(notificationView)
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
        
        // // settingsTable constraints
        let settingsTableConstraints = [
            settingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsTable.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 20),
            settingsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        let notificationViewConstraints = [
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationView.heightAnchor.constraint(equalToConstant: 60),
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20)
        ]
        
        // activate constraints
        NSLayoutConstraint.activate(topSeparatorViewConstraints)
        NSLayoutConstraint.activate(settingsTableConstraints)
        NSLayoutConstraint.activate(notificationViewConstraints)
    }

    
    //MARK: - Congifure nav bar
    private func configureNavBar() {
        let titleLbl: UILabel = {
            let lbl = UILabel()
            lbl.text = "Налаштування"
            lbl.textColor = .label
            lbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
            return lbl
        }()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLbl)
        navigationController?.navigationBar.tintColor = .label
        if #available(iOS 26.0, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    //MARK: - Request rate
    private func requestAppReview() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    //MARK: - Share app
    private func shareApp() {
        guard let appUrl = URL(string: "https://apps.apple.com/app/id6448219063") else { return }
        let shareText = "Додаток єЗброя"
        let itemsToShare: [Any] = [shareText, appUrl]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(activityVC, animated: true)
    }
    
}

//MARK: - Lifecycle
extension SettingsVC {
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.async { [weak self] in
            self?.settingsTable.reloadData()
        }
    }
}


//MARK: - UITableViewDelegate & DataSource
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    // apply table delegates
    private func applyTableDelegates() {
        settingsTable.delegate = self
        settingsTable.dataSource = self
    }
    
    // nubers of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    // height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier) as? SettingCell else { return UITableViewCell() }
        if indexPath.row == settings.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        }
        let setting = settings[indexPath.row]
        cell.configure(with: setting)
        return cell
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = settings[indexPath.row].type
        
        switch cellType {
            
        case .proposition:
            guard let url = URL(string: "https://t.me/+PVWEj8dQDSk5Mjgy") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            
            
        case .about:
            let vc = AboutVC()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(vc, animated: true)
            
            
        case .favorite:
            let vc = FavoritesVC()
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(vc, animated: true)
            
            
        case .rate:
            requestAppReview()
            
            
        case .share:
            shareApp()
            
            
        case .thank:
            print("thank")

        case .cache:
            print("CACHE")
            notificationView.configure(with: "Кеш видалено")
            notificationView.transform = CGAffineTransform(translationX: 0, y: -500)
            notificationView.isHidden = false
            settingsTable.isUserInteractionEnabled = false
            
            // deleting cache
            SDImageCache.shared.clearDisk()
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.notificationView.transform = .identity
            } completion: { _ in
                    UIView.animate(withDuration: 0.5, delay: 1.5) { [weak self] in
                        self?.notificationView.transform = CGAffineTransform(translationX: 0, y: -500)
                    } completion: { [weak self] _ in
                        self?.notificationView.isHidden = true
                        self?.settingsTable.isUserInteractionEnabled = true
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.settingsTable.reloadData()
                        }
                    }
                

            }
            
            
        }
    }
    
}

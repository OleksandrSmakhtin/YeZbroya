//
//  TabBarController.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 16.04.2023.
//



import UIKit

class TabBarController: UITabBarController {
    
        // MARK: - UI
        private let indicatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .black.withAlphaComponent(0.7)
            view.layer.cornerRadius = 2.5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
        // MARK: - Properties
        private var indicatorCenterXConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTabs()
        configureTabBar()
        
        
        if #available(iOS 26.0, *) {
            indicatorView.isHidden = true
        }
        
        if UIScreen.main.nativeBounds.height == 1334 {
            indicatorView.isHidden = true
        }


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // при первом запуске двигаем индикатор к текущему табу
        moveIndicator(to: selectedIndex, animated: false)
    }
    
    // MARK: - Setup Tabs
    private func setupTabs() {
        let vc1 = UINavigationController(rootViewController: GunVC())
        vc1.tabBarItem.image = UIImage(named: "gun")
        vc1.tabBarItem.selectedImage = UIImage(named: "gunFill")
        vc1.tabBarItem.title = "Зброя"
        
        let vc2 = UINavigationController(rootViewController: TechniqueVC())
        vc2.tabBarItem.image = UIImage(named: "teq")
        vc2.tabBarItem.selectedImage = UIImage(named: "teqFill")
        vc2.tabBarItem.title = "Техніка"
        
        let vc3 = UINavigationController(rootViewController: SearchVC())
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18))
        vc3.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass",
                                               withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        vc3.tabBarItem.title = "Пошук"
        
        let vc4 = UINavigationController(rootViewController: SettingsVC())
        vc4.tabBarItem.image = UIImage(systemName: "slider.horizontal.3")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "slider.horizontal.3", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        vc4.tabBarItem.title = "Інше"
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
    // MARK: - Configure TabBar
    private func configureTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        
                tabBar.addSubview(indicatorView)
        
        // базовые constraints индикатора
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: tabBar.leadingAnchor)
        
        NSLayoutConstraint.activate([
            indicatorCenterXConstraint!,
            indicatorView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: -15),
            indicatorView.heightAnchor.constraint(equalToConstant: 5),
            indicatorView.widthAnchor.constraint(equalToConstant: 5)
        ])

    }
    
    // MARK: - Indicator Movement
    private func moveIndicator(to index: Int, animated: Bool = true) {
        guard let items = tabBar.items, !items.isEmpty else { return }
        
        let tabWidth = tabBar.bounds.width / CGFloat(items.count)
        let centerX = tabWidth * (CGFloat(index) + 0.5)
        
         indicatorCenterXConstraint?.constant = centerX
        
        let animations = {
            self.tabBar.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    



    
    
    
    // MARK: - Did select item
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(of: item) {
            animateToTab(toIndex: index)
            moveIndicator(to: index)
        }
    }
    
    // MARK: - Transition Animation
    private func animateToTab(toIndex: Int) {
        guard let fromView = selectedViewController?.view,
              let toView = viewControllers?[toIndex].view,
              fromView != toView else { return }
        
        UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
    }
}




//
//  RootViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/14/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class GlobalRootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Adagio.backgroundColor
    }
    
    func setTabBarViewController() {
        let tabBarViewController = RootViewController()
        self.addChild(tabBarViewController)
        view.addSubview(tabBarViewController.view)
        tabBarViewController.didMove(toParent: self)
    }
}

class RootViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeRootViewController(viewModel: homeViewModel)
        
        let piecesViewModel = PiecesViewModel()
        let piecesViewController = PiecesRootViewController(viewModel: piecesViewModel)
        
        let youViewModel = YouViewModel()
        let youViewController = YouRootViewController(viewModel: youViewModel)
        
        self.viewControllers = [homeViewController, piecesViewController, youViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = UIColor.Adagio.textColor
        tabBar.backgroundColor = UIColor.Adagio.backgroundColor
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        tabBar.frame.size.height -= self.additionalSafeAreaInsets.bottom
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
    }
}

//
//  AdagioViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class MainAdagioViewController: BasicViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.changeLargeTitleFont(to: UIFont.systemFont(ofSize: 36, weight: .semibold), color: UIColor.Adagio.textColor)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.Adagio.backgroundColor
    }
    
    func setTabBarItem(_ defaultImage: UIImage?, selectedImage: UIImage?, insets: UIEdgeInsets = .zero) {
        let tabBarItem = UITabBarItem(title: nil, image: defaultImage, selectedImage: selectedImage)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], for: .normal)
        tabBarItem.imageInsets = insets
        self.tabBarItem = tabBarItem
    }
}

class SubAdagioViewController: BasicViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.changeLargeTitleFont(to: UIFont.systemFont(ofSize: 36, weight: .semibold), color: UIColor.Adagio.textColor)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.Adagio.backgroundColor
    }
}

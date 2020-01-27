//
//  AppDelegate.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/14/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.rootViewController = GlobalRootViewController()
        
        CoreDataManager.start(modelName: "AdagioModel", completion: setRootViewController)
        
        return true
    }
    
    private func setRootViewController() {
        guard let rootViewController = window?.rootViewController as? GlobalRootViewController else { assertionFailure(); return }
        rootViewController.setTabBarViewController()
    }
}

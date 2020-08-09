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
        
        let launchStoryBoard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        window?.rootViewController = launchStoryBoard.instantiateInitialViewController()
        
        CoreDataManager.start(modelName: "AdagioModel", completion: setRootViewController)
        
        if !UserDefaults.standard.firstLaunch {
            setDefaults()
        }
        
        return true
    }
    
    private func setRootViewController() {
        let root = RootViewController()
        root.modalPresentationStyle = .fullScreen
        root.modalTransitionStyle = .crossDissolve
        // Have to select a different tab rather than home and then select home in order
        // to get the effect of the selected home tab
        root.selectedIndex = 1
        window?.rootViewController?.present(root, animated: true, completion: nil)
        root.selectedIndex = 0
        
//        CurrentPracticeState.core.fire(.loadCurrentPractice)
    }
    
    private func setDefaults() {
        UserDefaults.standard.vibrationsEnabled = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
//        CurrentPracticeState.core.fire(.saveCurrentPractice)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        CurrentPracticeState.core.fire(.loadCurrentPractice)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        CurrentPracticeState.core.fire(.saveCurrentPractice)
    }
}

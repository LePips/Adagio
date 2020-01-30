//
//  RootViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/14/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentPracticeState.core.addSubscriber(subscriber: self, update: RootViewController.update)
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

extension RootViewController: Subscriber {
    
    func update(state: CurrentPracticeState) {
        guard let lastEvent = CurrentPracticeState.core.lastEvent else { return }
        switch lastEvent {
        case .startNewPractice(let newPractice, let managedObjectContext):
            let practiceViewModel = PracticeViewModel(practice: newPractice, managedObjectContext: managedObjectContext)
            let practiceViewController = PracticeRootViewController(viewModel: practiceViewModel)
            self.present(practiceViewController, animated: true, completion: nil)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .saveCurrentPractice: ()
            
        case .loadCurrentPractice: ()
            
        case .endPractice(_): ()
            
        }
    }
}

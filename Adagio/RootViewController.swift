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
    
    private lazy var currentSessionBar = makeCurrentSessionBar()
    
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
    
    func setupSubviews() {
        view.addSubview(currentSessionBar)
        currentSessionBar.alpha = 0
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            currentSessionBar.leftAnchor ⩵ view.leftAnchor,
            currentSessionBar.rightAnchor ⩵ view.rightAnchor,
            currentSessionBar.heightAnchor ⩵ 50,
            currentSessionBar.bottomAnchor ⩵ tabBar.topAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        
        CurrentPracticeState.core.addSubscriber(subscriber: self, update: RootViewController.update)
        CurrentTimerState.core.addSubscriber(subscriber: self, update: RootViewController.update)
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
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        tabBar.frame.size.height -= self.additionalSafeAreaInsets.bottom
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
    }
    
    private func makeCurrentSessionBar() -> CurrentSessionBar {
        let view = CurrentSessionBar.forAutoLayout()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(currentSessionSelected))
        view.addGestureRecognizer(tapRecognizer)
        return view
    }
    
    @objc private func currentSessionSelected() {
        guard let currentPractice = CurrentPracticeState.core.state.practice else { return }
        guard let managedObjectContext = CurrentPracticeState.core.state.managedObjectContext else { return }
        let currentPracticeViewModel = PracticeViewModel(practice: currentPractice, managedObjectContext: managedObjectContext)
        let currentPracticeViewController = PracticeRootViewController(viewModel: currentPracticeViewModel)
        self.present(currentPracticeViewController, animated: true, completion: nil)
    }
}

extension RootViewController: Subscriber {
    
    func update(state: CurrentPracticeState) {
        guard let lastEvent = CurrentPracticeState.core.lastEvent else { return }
        switch lastEvent {
        case .startNewPractice(let newPractice, let managedObjectContext):
            let practiceViewModel = PracticeViewModel(practice: newPractice, managedObjectContext: managedObjectContext)
            let practiceViewController = PracticeRootViewController(viewModel: practiceViewModel)
            self.present(practiceViewController, animated: true, completion: newPracticePresented)
            currentSessionBar.configure(practice: newPractice)
        case .saveCurrentPractice: ()
            
        case .loadCurrentPractice: ()
            
        case .deleteCurrentPractice(_), .endPractice(_):
            currentSessionBar.configure(practice: nil)
            currentSessionBar.alpha = 0
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        }
    }
    
    private func newPracticePresented() {
        currentSessionBar.alpha = 1
        self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -65, right: 0)
    }
    
    func update(state: CurrentTimerState) {
        currentSessionBar.set(duration: state.currentInterval)
    }
}

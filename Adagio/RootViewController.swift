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
    private lazy var sessionBarHeightAnchor = makeSessionBarHeightAnchor()
    
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
            currentSessionBar.bottomAnchor ⩵ tabBar.topAnchor,
            sessionBarHeightAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
        
        CurrentPracticeState.core.addSubscriber(subscriber: self, update: RootViewController.update)
        CurrentTimerState.core.addSubscriber(subscriber: self, update: RootViewController.update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.items?.forEach({ (tabBarItem) in
            tabBarItem.title = nil
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let practice = Practice(context: CoreDataManager.main.mainManagedObjectContext)
//        practice.title = "Evening Practice"
//        practice.startDate = Date()
//        practice.endDate = Date().addingTimeInterval(3000)
//        
//        let section = Section(context: CoreDataManager.main.mainManagedObjectContext)
//        section.title = "C Major Scales"
//        section.startDate = Date().addingTimeInterval(300)
//        section.endDate = Date().addingTimeInterval(600)
//        practice.addToSections(section)
//        
//        let warmUp = Section(context: CoreDataManager.main.mainManagedObjectContext)
//        warmUp.title = "D Minor Scales"
//        warmUp.startDate = Date().addingTimeInterval(300)
//        warmUp.endDate = Date().addingTimeInterval(600)
//        warmUp.warmUp = true
//        practice.addToSections(warmUp)
//        
//        for i in 0...10 {
//            let section = Section(context: CoreDataManager.main.mainManagedObjectContext)
//            section.title = "C Major Scales"
//            section.startDate = Date().addingTimeInterval(300)
//            section.endDate = Date().addingTimeInterval(600)
//            practice.addToSections(section)
//        }
//        
//        let viewModel = EndPracticeViewModel(practice: practice)
//        present(EndPracticeViewController(viewModel: viewModel), animated: false, completion: nil)
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
    
    private func makeSessionBarHeightAnchor() -> NSLayoutConstraint {
        return currentSessionBar.heightAnchor ⩵ 50
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
            
        case .deleteCurrentPractice(_):
            currentSessionBar.configure(practice: nil)
            currentSessionBar.alpha = 0
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
        case .endPractice(let practice):
            currentSessionBar.configure(practice: nil)
            currentSessionBar.alpha = 0
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0)
            
            let endPracticeViewModel = EndPracticeViewModel(practice: practice)
            let endPracticeViewController = EndPracticeViewController(viewModel: endPracticeViewModel)
            endPracticeViewController.modalPresentationStyle = .fullScreen
            endPracticeViewController.modalTransitionStyle = .crossDissolve
            present(endPracticeViewController, animated: true, completion: nil)
        case .focus(_):
            currentSessionBar.configure(practice: state.practice, section: state.section)
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -85, right: 0)
            sessionBarHeightAnchor.constant = 70
            view.layoutIfNeeded()
        case .endFocusSection:
            currentSessionBar.configure(practice: state.practice)
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: -65, right: 0)
            sessionBarHeightAnchor.constant = 50
            view.layoutIfNeeded()
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

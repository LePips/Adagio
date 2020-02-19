//
//  RootPracticeViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

protocol RootPracticeProtocol {
    
    func presentChoosePieceViewController()
    func dismissChoosePieceViewController()
    
    func focus(piece: Piece)
    func endFocusSection()
}

class PracticeRootViewController: BasicViewController, RootPracticeProtocol {
    
    private lazy var practiceViewController = makePracticeViewController()
    private lazy var choosePieceViewController = makeChoosePieceViewController()
    private lazy var choosePieceViewTopAnchor = makeChoosePieceViewTopAnchor()
    private lazy var focusSectionViewController = makeFocusSectionViewController()
    private lazy var focusSectionViewTopAnchor = makeFocusSectionViewTopAnchor()
    
    private let practiceViewModel: PracticeViewModel
    
    override func setupSubviews() {
        self.addChild(practiceViewController)
        view.embed(practiceViewController.view)
        
        self.addChild(choosePieceViewController)
        view.addSubview(choosePieceViewController.view)
        
        self.addChild(focusSectionViewController)
        view.addSubview(focusSectionViewController.view)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            choosePieceViewTopAnchor,
            choosePieceViewController.view.leftAnchor ⩵ view.leftAnchor,
            choosePieceViewController.view.rightAnchor ⩵ view.rightAnchor,
            choosePieceViewController.view.heightAnchor ⩵ view.heightAnchor
        ])
        NSLayoutConstraint.activate([
            focusSectionViewTopAnchor,
            focusSectionViewController.view.leftAnchor ⩵ view.leftAnchor,
            focusSectionViewController.view.rightAnchor ⩵ view.rightAnchor,
            focusSectionViewController.view.heightAnchor ⩵ view.heightAnchor
        ])
    }
    
    init(viewModel: PracticeViewModel) {
        self.practiceViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choosePieceViewTopAnchor.constant = view.bounds.height
        focusSectionViewTopAnchor.constant = view.bounds.height
        view.layoutIfNeeded()
        
        if let currentSection = CurrentPracticeState.core.state.section {
            load(with: currentSection)
        }
    }
    
    func presentChoosePieceViewController() {
        choosePieceViewTopAnchor.constant = 0
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissChoosePieceViewController() {
        choosePieceViewTopAnchor.constant = view.bounds.height
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func focus(piece: Piece) {
        dismissChoosePieceViewController()
        
        let section = practiceViewModel.createPieceSection(with: piece)
        practiceViewModel.focus(section: section)
        let focusSectionViewModel = FocusSectionViewModel(section: section, managedObjectContext: section.managedObjectContext!, sectionFinishAction: self.endFocusSection)
        focusSectionViewController.configure(viewModel: focusSectionViewModel)
        
        focusSectionViewTopAnchor.constant = 0
        
        UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func load(with section: Section) {
        let focusSectionViewModel = FocusSectionViewModel(section: section, managedObjectContext: section.managedObjectContext!, sectionFinishAction: practiceViewModel.endFocusSection)
        focusSectionViewController.configure(viewModel: focusSectionViewModel)
        
        focusSectionViewTopAnchor.constant = 0
        view.layoutIfNeeded()
    }
    
    func endFocusSection() {
        practiceViewModel.endFocusSection()
        
        practiceViewModel.createRows()
        
        focusSectionViewTopAnchor.constant = view.bounds.height
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func makePracticeViewController() -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: PracticeViewController(viewModel: practiceViewModel, rootPractice: self))
        navigationViewController.view.translatesAutoresizingMaskIntoConstraints = false
        navigationViewController.makeBarTransparent()
        return navigationViewController
    }
    
    private func makeChoosePieceViewController() -> UIViewController {
        let choosePieceViewModel = ChoosePieceViewModel(pieceSelectedAction: focus(piece:))
        return ChoosePieceRootViewController(viewModel: choosePieceViewModel, rootPractice: self)
    }
    
    private func makeChoosePieceViewTopAnchor() -> NSLayoutConstraint {
        return choosePieceViewController.view.topAnchor ⩵ view.topAnchor
    }
    
    private func makeFocusSectionViewController() -> FocusSectionRootViewController {
        return FocusSectionRootViewController(focusSectionViewController: FocusSectionViewController())
    }
    
    private func makeFocusSectionViewTopAnchor() -> NSLayoutConstraint {
        return focusSectionViewController.view.topAnchor ⩵ view.topAnchor
    }
}

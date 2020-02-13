//
//  HomeViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class HomeRootViewController: UINavigationController {
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [HomeViewController(viewModel: viewModel)]
        self.makeBarTransparent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class HomeViewController: MainAdagioViewController {
    
    private lazy var collectionView = makeCollectionView()
    private lazy var startPracticeLabel = makeStartPracticeLabel()
    private lazy var startPracticeButton = makeStartPracticeButton()
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        let houseConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        self.setTabBarItem(UIImage(systemName: "house", withConfiguration: houseConfiguration),
                           selectedImage: UIImage(systemName: "house.fill", withConfiguration: houseConfiguration))
        self.title = "Home"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.embed(collectionView)
        view.addSubview(startPracticeButton)
        view.addSubview(startPracticeLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            startPracticeButton.rightAnchor ⩵ view.rightAnchor - 25,
            startPracticeButton.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor - 50,
            startPracticeButton.heightAnchor ⩵ 70,
            startPracticeButton.widthAnchor ⩵ 70
        ])
        NSLayoutConstraint.activate([
            startPracticeLabel.centerXAnchor ⩵ view.centerXAnchor,
            startPracticeLabel.centerYAnchor ⩵ view.centerYAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentPracticeState.core.addSubscriber(subscriber: self, update: HomeViewController.update)
        
        viewModel.reloadRows()
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BouncyLayout(style: .moreSubtle))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        HomeRow.register(collectionView: collectionView)
        return collectionView
    }
    
    private func makeStartPracticeLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Let's start a\npractice today"
        return label
    }
    
    private func makeStartPracticeButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.addTarget(self, action: #selector(startPracticeSelected), for: .touchUpInside)
        let plusConfiguration = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        button.setImage(UIImage(systemName: "plus", withConfiguration: plusConfiguration), for: .normal)
        button.setBackgroundColor(UIColor.systemBlue, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 35
        return button
    }
    
    @objc private func startPracticeSelected() {
        let privateContext = CoreDataManager.main.privateChildManagedObjectContext()
        let newPractice = Practice(context: privateContext)
        CurrentPracticeState.core.fire(.startNewPractice(newPractice, privateContext))
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.rows.count == 1 {
            startPracticeLabel.alpha = 1
            startPracticeLabel.text = "Let's start a\npractice today"
        }
        return viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.row <= viewModel.rows.count else { return CGSize(width: UIScreen.main.bounds.width, height: 0)}
        return CGSize(width: UIScreen.main.bounds.width, height: viewModel.rows[indexPath.row].height())
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.startPracticeLabel.isHidden = self.viewModel.rows.count - 1 != 0
            self.collectionView.isScrollEnabled = self.viewModel.rows.count - 1 != 0
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: Subscriber {
    
    func update(state: CurrentPracticeState) {
        guard let lastEvent = CurrentPracticeState.core.lastEvent else { return }
        switch lastEvent {
        case .startNewPractice(_, _):
            UIView.animate(withDuration: 0.2) {
                self.startPracticeButton.alpha = 0
            }
            if viewModel.rows.count == 1 {
                UIView.animate(withDuration: 0.2, delay: 0.5, options: [], animations: {
                    self.startPracticeLabel.alpha = 0
                }) { (_) in
                    self.startPracticeLabel.text = "You are currently practicing"
                    UIView.animate(withDuration: 0.2) {
                        self.startPracticeLabel.alpha = 1
                    }
                }
            }
        case .endPractice(_), .deleteCurrentPractice(_):
            UIView.animate(withDuration: 0.2) {
                self.startPracticeButton.alpha = 1
            }
            self.collectionView.reloadData()
        default: ()
        }
    }
}

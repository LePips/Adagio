//
//  YouViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class YouRootViewController: UINavigationController {
    
    init(viewModel: YouViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [YouViewController(viewModel: viewModel)]
        makeBarTransparent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class YouViewController: MainAdagioViewController {
    
    private lazy var collectionView = makeCollectionView()
    
    let viewModel: YouViewModel
    
    init(viewModel: YouViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        let personConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        self.setTabBarItem(UIImage(systemName: "person", withConfiguration: personConfiguration),
                           selectedImage: UIImage(systemName: "person.fill", withConfiguration: personConfiguration))
        self.title = "You"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.embed(collectionView)
    }
    
    override func setupLayoutConstraints() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadRows()
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsSelected))
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationController?.navigationBar.tintColor = UIColor.Adagio.textColor
    }
    
    @objc private func settingsSelected() {
        var settingsRows = SettingsSectionType.allCases.compactMap({ SettingsRow.section($0) })
        settingsRows.append(.purge)
        settingsRows.append(.setTestData)
        let settingsViewModel = SettingsViewModel(title: "Settings",
                                                  rows:  settingsRows)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BouncyLayout(style: .moreSubtle))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        YouRow.register(collectionView: collectionView)
        return collectionView
    }
}

extension YouViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: viewModel.rows[indexPath.row].height())
    }
}

extension YouViewController: YouViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

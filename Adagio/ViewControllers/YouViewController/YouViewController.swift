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
    
    private lazy var tableView = makeTableView()
    
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
        view.embed(tableView)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadRows()
    }
    
    @objc private func settingsSelected() {
        var settingsRows = SettingsSectionType.allCases.compactMap({ SettingsRow.section($0) })
        settingsRows.append(.purge)
        let settingsViewModel = SettingsViewModel(title: "Settings",
                                                  rows:  settingsRows)
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        YouRow.register(tableView: tableView)
        return tableView
    }
}

extension YouViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rows[indexPath.row].height()
    }
}

extension YouViewController: YouViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

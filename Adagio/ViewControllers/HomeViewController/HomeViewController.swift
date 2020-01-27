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
    
    private lazy var tableView = makeTableView()
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
        view.embed(tableView)
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
        viewModel.reloadRows()
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        HomeRow.register(tableView: tableView)
        return tableView
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
        button.setBackgroundColor(UIColor.systemBlue.withAlphaComponent(0.15))
        button.layer.cornerRadius = 35
        return button
    }
    
    @objc private func startPracticeSelected() {
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        let newPractice = Practice(context: managedObjectContext)
        let practiceViewModel = PracticeViewModel(practice: newPractice, managedObjectContext: managedObjectContext)
        let practiceViewController = PracticeRootViewController(viewModel: practiceViewModel)
        self.present(practiceViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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

extension HomeViewController: HomeViewModelDelegate {
    func reloadRows() {
        startPracticeLabel.isHidden = self.viewModel.rows.count - 1 != 0
        tableView.isScrollEnabled = self.viewModel.rows.count - 1 != 0
        tableView.reloadData()
    }
}

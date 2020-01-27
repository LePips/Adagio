//
//  PracticeViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PracticeRootViewController: UINavigationController {
    
    init(viewModel: PracticeViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [PracticeViewController(viewModel: viewModel)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class PracticeViewController: MainAdagioViewController {
    
    private lazy var tableView = makeTableView()
    
    let viewModel: PracticeViewModel
    
    init(viewModel: PracticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        
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
        
        let closeConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let closeBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle.fill", withConfiguration: closeConfiguration), style: .plain, target: self, action: #selector(closeSelected))
        let finishBarButton = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = finishBarButton
    }
    
    @objc private func closeSelected() {
        
    }
    
    @objc private func finishSelected() {
        
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }
}

extension PracticeViewController: PracticeViewModelDelegate {
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.updateRows()
        }
    }
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PracticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

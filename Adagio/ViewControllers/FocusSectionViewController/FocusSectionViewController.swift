//
//  FocusSectionViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/27/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class FocusSectionRootViewController: UINavigationController {
    
    init(viewModel: FocusSectionViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [FocusSectionViewController(viewModel: viewModel)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class FocusSectionViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    
    private let viewModel: FocusSectionViewModel
    
    init(viewModel: FocusSectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        FocusSectionRow.register(tableView: tableView)
        return tableView
    }
}

extension FocusSectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: tableView)
    }
}

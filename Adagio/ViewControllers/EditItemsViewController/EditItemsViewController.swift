//
//  EditItemsViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class EditItemsViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    
    let viewModel: EditItemsViewModelProtocol
    
    init(viewModel: EditItemsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delgate = self
        self.title = viewModel.title
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
        reloadRows()
        
        let createButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createItemSelected))
        self.navigationItem.rightBarButtonItem = createButtonItem
    }
    
    @objc private func createItemSelected() {
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        let newInstrument = Instrument(context: managedObjectContext)
        newInstrument.title = "Piano \(Date())"
        newInstrument.save(writeToDisk: true) { (result) in
            switch result {
            case .success:
                self.viewModel.reloadRows()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        EditItemRow.register(tableView: tableView)
        return tableView
    }
}

extension EditItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension EditItemsViewController: EditItemsViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

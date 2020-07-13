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
    private lazy var searchController = makeSearchController()
    
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
        viewModel.createItem()
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
    
    private func makeSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Item"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        return searchController
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
    
    func presentCreateInstrumentViewController(with viewModel: CreateItemViewModel<Instrument>) {
        let alertViewController = UIAlertController(title: "Create Instrument", message: nil, preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.enablesReturnKeyAutomatically = true
            textField.returnKeyType = .done
            textField.addTarget(alertViewController, action: #selector(alertViewController.textDidChangeNotEmpty), for: .editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: .none)
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            viewModel.set(text: alertViewController.textFields?.first?.text)
            viewModel.saveItem()
        }
        createAction.isEnabled = false
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(createAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func presentCreateGroupViewController(with viewModel: CreateItemViewModel<Group>) {
        let alertViewController = UIAlertController(title: "Create Group", message: nil, preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.enablesReturnKeyAutomatically = true
            textField.returnKeyType = .done
            textField.addTarget(alertViewController, action: #selector(alertViewController.textDidChangeNotEmpty), for: .editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: .none)
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            viewModel.set(text: alertViewController.textFields?.first?.text)
            viewModel.saveItem()
        }
        createAction.isEnabled = false
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(createAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension EditItemsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
        tableView.reloadData()
    }
}

extension UIAlertController {
    
    @objc func textDidChangeNotEmpty() {
        guard let textField = textFields?.first else { return }
        guard let addAction = actions.last else { return }
        if let text = textField.text {
            addAction.isEnabled = !text.isEmpty
        } else {
            addAction.isEnabled = false
        }
    }
    
    @objc private func doneKeySelected() {
        
    }
}

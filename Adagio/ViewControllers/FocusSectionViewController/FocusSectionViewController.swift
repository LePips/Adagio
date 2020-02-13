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
        self.makeBarTransparent()
        
        self.modalPresentationStyle = .fullScreen
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let closeConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let closeBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle.fill", withConfiguration: closeConfiguration), style: .plain, target: self, action: #selector(closeSelected))
        let finishBarButton = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = finishBarButton
    }
    
    @objc private func closeSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rows[indexPath.row].height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: Selectable? = tableView.visibleCells[indexPath.row] as? Selectable
        cell?.select()
    }
}

extension FocusSectionViewController: FocusSectionViewModelDelegate {
    
    func reloadRows() {
        tableView.reloadData()
    }
    
    func updateRows() {
        tableView.updateRows()
    }
    
    func set(warmUp: Bool) {
        if warmUp {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.3)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.backgroundColor = .clear
            }
        }
    }
}

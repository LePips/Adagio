//
//  PracticeViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import CoreData
import SharedPips

class PracticeViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    private lazy var hideKeyboardButton = makeHideKeyboardButton()
    private lazy var keyboardTopAnchor = makeKeyboardTopAnchor()
    
    let viewModel: PracticeViewModelProtocol
    let rootPractice: RootPracticeProtocol
    
    init(viewModel: PracticeViewModelProtocol, rootPractice: RootPracticeProtocol) {
        self.viewModel = viewModel
        self.rootPractice = rootPractice
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(hideKeyboardButton)
        hideKeyboardButton.alpha = 0
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor ⩵ view.safeAreaLayoutGuide.topAnchor,
            tableView.leftAnchor ⩵ view.leftAnchor,
            tableView.rightAnchor ⩵ view.rightAnchor,
            keyboardTopAnchor
        ])
        NSLayoutConstraint.activate([
            hideKeyboardButton.heightAnchor ⩵ 40,
            hideKeyboardButton.widthAnchor ⩵ 40,
            hideKeyboardButton.rightAnchor ⩵ view.rightAnchor - 17,
            hideKeyboardButton.bottomAnchor ⩵ tableView.bottomAnchor - 17
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let closeConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let closeBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle.fill", withConfiguration: closeConfiguration), style: .plain, target: self, action: #selector(closeSelected))
        let finishBarButton = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = finishBarButton
        
        self.reloadRows()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        CurrentTimerState.core.addSubscriber(subscriber: self, update: PracticeViewController.update)
    }
    
    @objc private func closeSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishSelected() {
        CurrentPracticeState.core.fire(.endPractice(viewModel.practice))
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardTopAnchor.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.2) {
                self.hideKeyboardButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardTopAnchor.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.hideKeyboardButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        PracticeRow.register(tableView: tableView)
        return tableView
    }
    
    private func makeHideKeyboardButton() -> HideKeyboardButton {
        let button = HideKeyboardButton()
        button.addTarget(self, action: #selector(hideKeyboardSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func hideKeyboardSelected() {
        view.endEditing(true)
    }
    
    private func makeKeyboardTopAnchor() -> NSLayoutConstraint {
        return tableView.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor
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
    
    func addPieceSelected() {
        rootPractice.presentChoosePieceViewController()
    }
    
    func deletePracticeSelected() {
        if CurrentTimerState.core.state.currentInterval < 60 {
            self.viewModel.deletePracticeConfirmed()
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let alertViewController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this practice?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.viewModel.deletePracticeConfirmed()
            self.dismiss(animated: true, completion: nil)
        }
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(confirmAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension PracticeViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension PracticeViewController: Subscriber {
    
    func update(state: CurrentTimerState) {
        let currentInterval = state.currentInterval
        var currentTitle: String?

        if currentInterval < 60 {
            if currentInterval > 9 {
                currentTitle = "0:\(Int(currentInterval))"
            } else {
                currentTitle = "0:0\(Int(currentInterval))"
            }
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .dropLeading
            formatter.allowedUnits = [.second, .minute, .hour]
            currentTitle = formatter.string(from: currentInterval)
        }
        
        self.title = currentTitle
    }
}

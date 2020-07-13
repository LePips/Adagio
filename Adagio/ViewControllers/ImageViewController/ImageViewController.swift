//
//  ImageViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class ImageRootViewController: UINavigationController, UIAdaptivePresentationControllerDelegate {
    
    private let viewModel: ImageViewModel
    
    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.makeBarTransparent()
        
        self.presentationController?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ImageViewController(viewModel: viewModel)]
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !viewModel.editing
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        viewModel.saveAction()
    }
}

class ImageViewController: SubAdagioViewController, UIAdaptivePresentationControllerDelegate {
    
    private lazy var tableView = makeTableView()
    private lazy var hideKeyboardButton = makeHideKeyboardButton()
    private lazy var keyboardTopAnchor = makeKeyboardTopAnchor()
    
    private let viewModel: ImageViewModel
    
    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
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
            keyboardTopAnchor,
            tableView.topAnchor ⩵ view.safeAreaLayoutGuide.topAnchor,
            tableView.leftAnchor ⩵ view.leftAnchor,
            tableView.rightAnchor ⩵ view.rightAnchor
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
        
        reloadRows()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSelected))
        self.navigationItem.setLeftBarButton(closeBarButton, animated: true)
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func editSelected() {
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSelected))
        let deleteBarButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelected))
        deleteBarButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .normal)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(saveBarButton, animated: true)
        self.navigationItem.setLeftBarButton(deleteBarButton, animated: true)
        
        viewModel.editing = true
        
        tableView.visibleCells.forEach { (cell) in
            guard var editableCell = cell as? Editable else { return }
            editableCell.isEditing = true
        }
    }
    
    @objc private func saveSelected() {
        doneSelected()
    }
    
    @objc private func closeSelected() {
        viewModel.saveAction()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteSelected() {
        viewModel.delete()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneSelected() {
        
        let verifiableCells = tableView.visibleCells.compactMap({ $0 as? Verifiable })
        guard verifiableCells.allSatisfy({ $0.isValid }) else {
            let invalidCells = verifiableCells.filter({ !$0.isValid })
            invalidCells.forEach { (cell) in
                cell.setInvalid()
            }
            Haptics.main.error()
            return
        }
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSelected))
        self.navigationItem.setLeftBarButton(closeBarButton, animated: true)
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
        
        viewModel.editing = false
        
        tableView.visibleCells.forEach { (cell) in
            guard var editableCell = cell as? Editable else { return }
            editableCell.isEditing = false
        }
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
        ImageRow.register(tableView: tableView)
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
        return tableView.bottomAnchor ⩵ view.bottomAnchor
    }
}

extension ImageViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension ImageViewController: ImageViewModelDelegate {
    
    func updateRows() {
        tableView.updateRows()
    }
    
    func reloadRows() {
        tableView.reloadData()
    }
}

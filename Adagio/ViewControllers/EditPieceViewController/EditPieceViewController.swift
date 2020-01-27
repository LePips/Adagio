//
//  EditPieceViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class EditPieceRootViewController: UINavigationController {
    
    init(viewModel: EditPieceViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [EditPieceViewController(viewModel: viewModel)]
        self.makeBarTransparent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class EditPieceViewController: SubAdagioViewController, UIAdaptivePresentationControllerDelegate {
    
    private lazy var tableView = makeTableView()
    
    private let viewModel: EditPieceViewModel
    
    init(viewModel: EditPieceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        self.isModalInPresentation = true
        self.title = "Create Piece"
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
        self.prefersLargeTitles = false
        
        if viewModel.editing {
            let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected))
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneSelected))
            self.navigationItem.leftBarButtonItem = cancelBarButton
            self.navigationItem.rightBarButtonItem = doneBarButton
        } else {
            let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
            let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSelected))
            self.navigationItem.setLeftBarButton(closeBarButton, animated: true)
            self.navigationItem.setRightBarButton(editBarButton, animated: true)
        }
        
        tableView.reloadData()
    }
    
    @objc private func cancelSelected() {
        
        if viewModel.isExisting {
            didSavePiece()
        } else {
            viewModel.close()
            dismiss()
        }
    }
    
    @objc private func doneSelected() {
        
        let verifiableCells = tableView.visibleCells.compactMap({ $0 as? Verifiable })
        guard verifiableCells.allSatisfy({ $0.isValid }) else {
            let invalidCells = verifiableCells.filter({ !$0.isValid })
            invalidCells.forEach { (cell) in
                cell.setInvalid()
            }
            return
        }
        
        viewModel.savePiece()
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        EditPieceRow.register(tableView: tableView)
        return tableView
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if viewModel.editing {
            let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertViewController.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { (_) in
                self.viewModel.close()
                self.dismiss()
            }))
            alertViewController.addAction(UIAlertAction(title: "Continue Editing", style: .cancel, handler: nil))
        }
    }
}

extension EditPieceViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension EditPieceViewController: EditPieceViewModelDelegate {
    
    func reloadRows() {
        tableView.reloadData()
    }
    
    func updateRows() {
        tableView.updateRows()
    }
    
    @objc func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func didSavePiece() {
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSelected))
        self.navigationItem.setLeftBarButton(closeBarButton, animated: true)
        self.navigationItem.setRightBarButton(editBarButton, animated: true)
        
        tableView.visibleCells.forEach { (cell) in
            guard var editableCell = cell as? Editable else { return }
            editableCell.isEditing = false
        }
    }
    
    @objc private func closeSelected() {
        self.dismiss()
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
    
    @objc private func deleteSelected() {
        let alertViewController = UIAlertController(title: "Warning!", message: "Do you want to delete \(viewModel.piece.title)? This will delete all occurences of \(viewModel.piece.title) in previous practices.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.viewModel.deletePiece()
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(deleteAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func presentInstrumentPicker(with viewModel: InstrumentPickerViewModel) {
        let createInstrumentPicker = PickerViewController(viewModel: viewModel)
        present(createInstrumentPicker, animated: true, completion: nil)
    }
    
    func presentGroupPicker(with viewModel: GroupPickerViewModel) {
        present(PickerViewController(viewModel: viewModel), animated: true, completion: nil)
    }
}

extension UITableView {
    
    func updateRows() {
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}

extension UIViewController {
    
    var rootViewController: UIViewController? {
        var holder: UIViewController? = self
        var current: UIViewController? = self
        
        while holder != nil {
            if holder?.parent != nil {
                current = current?.parent
            }
            
            holder = holder?.parent
        }
        
        return current
    }
}

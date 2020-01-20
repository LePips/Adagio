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

private class EditPieceViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    
    private let viewModel: EditPieceViewModel
    
    init(viewModel: EditPieceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
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
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelected))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        tableView.reloadData()
    }
    
    @objc private func cancelSelected() {
        dismiss(animated: true, completion: nil)
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
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentInstrumentPicker(with viewModel: CoreDataPickerViewModel<Instrument>) {
        let pickerViewController = PickerViewController(viewModel: viewModel)
        present(pickerViewController, animated: true, completion: nil)
    }
    
    func presentGroupPicker(with viewModel: CoreDataPickerViewModel<Group>) {
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

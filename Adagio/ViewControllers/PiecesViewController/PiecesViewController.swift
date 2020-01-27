//
//  PiecesViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PiecesRootViewController: UINavigationController {
    
    init(viewModel: PiecesViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [PiecesViewController(viewModel: viewModel)]
        makeBarTransparent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class PiecesViewController: MainAdagioViewController {
    
    private lazy var tableView = makeTableView()
    
    let viewModel: PiecesViewModel
    
    init(viewModel: PiecesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        
        let pieceConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        self.setTabBarItem(UIImage(named: "doc.music.empty")?.applyingSymbolConfiguration(pieceConfiguration),
                           selectedImage: UIImage(named: "doc.music.filled")?.applyingSymbolConfiguration(pieceConfiguration))
        self.title = "Pieces"
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
        
        let createPieceButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPieceSelected))
        self.navigationItem.rightBarButtonItem = createPieceButton
        self.navigationController?.navigationBar.tintColor = UIColor.Adagio.textColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    @objc private func createPieceSelected() {
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        let createPieceViewModel = EditPieceViewModel(piece: nil, managedObjectContext: managedObjectContext, editing: true)
        let createPieceViewController = EditPieceRootViewController(viewModel: createPieceViewModel)
        self.present(createPieceViewController, animated: true, completion: nil)
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        PiecesRow.register(tableView: tableView)
        return tableView
    }
}

extension PiecesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case PiecesRow.piece(let piece) = viewModel.rows[indexPath.row] {
            let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
            let createPieceViewModel = EditPieceViewModel(piece: piece, managedObjectContext: managedObjectContext, editing: false)
            let createPieceViewController = EditPieceRootViewController(viewModel: createPieceViewModel)
            self.present(createPieceViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmPieceDeletion(at: indexPath)
        }
    }
    
    private func confirmPieceDeletion(at path: IndexPath) {
        if case PiecesRow.piece(let piece) = viewModel.rows[path.row] {
            let alertViewController = UIAlertController(title: "Warning!", message: "Do you want to delete \(piece.title)? This will delete all occurences of \(piece.title) in previous practices.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: .none)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.viewModel.deletePiece(path: path)
            })
            
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(deleteAction)
            present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension PiecesViewController: PiecesViewModelDelegate {
    
    @objc func reloadRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

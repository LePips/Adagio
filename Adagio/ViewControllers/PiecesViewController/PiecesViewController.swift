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
    
    private lazy var collectionView = makeCollectionView()
    private lazy var noPiecesLabel = makeNoPiecesLabel()
    private lazy var searchController = makeSearchController()
    
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
        view.embed(collectionView)
        view.addSubview(noPiecesLabel)
        _ = searchController
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            noPiecesLabel.centerXAnchor ⩵ view.centerXAnchor,
            noPiecesLabel.centerYAnchor ⩵ view.centerYAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let createPieceButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPieceSelected))
        self.navigationItem.rightBarButtonItem = createPieceButton
        self.navigationController?.navigationBar.tintColor = UIColor.Adagio.textColor
        
        reloadRows()
    }
    
    @objc private func createPieceSelected() {
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        let createPieceViewModel = EditPieceViewModel(piece: nil, managedObjectContext: managedObjectContext, editing: true)
        let createPieceViewController = EditPieceRootViewController(viewModel: createPieceViewModel)
        Haptics.main.light()
        self.present(createPieceViewController, animated: true, completion: nil)
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BouncyLayout(style: .subtle))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        PiecesRow.register(collectionView: collectionView)
        return collectionView
    }
    
    private func makeNoPiecesLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "No pieces"
        return label
    }
    
    private func makeSearchController() -> UISearchController {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pieces"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = PieceSearchScope.titles
        searchController.searchBar.delegate = self
        return searchController
    }
}

extension PiecesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: collectionView, searchScope: viewModel.currentSearchScope)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case PiecesRow.piece(let piece) = viewModel.rows[indexPath.row] {
            let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
            let createPieceViewModel = EditPieceViewModel(piece: piece, managedObjectContext: managedObjectContext, editing: false)
            let createPieceViewController = EditPieceRootViewController(viewModel: createPieceViewModel)
            Haptics.main.light()
            self.present(createPieceViewController, animated: true, completion: nil)
        }
    }
}

extension PiecesViewController: PiecesViewModelDelegate {
    
    @objc func reloadRows() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.noPiecesLabel.isHidden = !self.viewModel.rows.isEmpty
            self.collectionView.alwaysBounceVertical = !self.viewModel.rows.isEmpty
        }
    }
}

extension PiecesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
        collectionView.reloadData()
    }
}

extension PiecesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            viewModel.currentSearchScope = .title
        case 1:
            viewModel.currentSearchScope = .composer
        case 2:
            viewModel.currentSearchScope = .instrument
        default:
            viewModel.currentSearchScope = .title
        }
    }
}

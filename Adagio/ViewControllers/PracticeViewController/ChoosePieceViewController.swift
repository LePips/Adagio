//
//  ChoosePieceViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/31/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import CoreData
import SharedPips

class ChoosePieceRootViewController: UINavigationController {
    
    init(viewModel: ChoosePieceViewModel, rootPractice: RootPracticeProtocol) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [ChoosePieceViewController(viewModel: viewModel, rootPractice: rootPractice)]
        makeBarTransparent()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChoosePieceViewController: MainAdagioViewController {
    
    private lazy var collectionView = makeCollectionView()
    private lazy var noPiecesLabel = makeNoPiecesLabel()
    
    let viewModel: ChoosePieceViewModel
    let rootPractice: RootPracticeProtocol
    
    init(viewModel: ChoosePieceViewModel, rootPractice: RootPracticeProtocol) {
        self.viewModel = viewModel
        self.rootPractice = rootPractice
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        
        let pieceConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        self.setTabBarItem(UIImage(named: "doc.music.empty")?.applyingSymbolConfiguration(pieceConfiguration),
                           selectedImage: UIImage(named: "doc.music.filled")?.applyingSymbolConfiguration(pieceConfiguration))
        self.title = "Add Piece"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.embed(collectionView)
        view.addSubview(noPiecesLabel)
        
        collectionView.alwaysBounceVertical = !viewModel.rows.isEmpty
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            noPiecesLabel.centerXAnchor ⩵ view.centerXAnchor,
            noPiecesLabel.centerYAnchor ⩵ view.centerYAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
        let createPieceButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createPieceSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = createPieceButton
        self.navigationController?.navigationBar.tintColor = UIColor.Adagio.textColor
        
        reloadRows()
    }
    
    @objc private func closeSelected() {
        self.rootPractice.dismissChoosePieceViewController()
    }
    
    @objc private func createPieceSelected() {
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        let createPieceViewModel = EditPieceViewModel(piece: nil, managedObjectContext: managedObjectContext, editing: true)
        let createPieceViewController = EditPieceRootViewController(viewModel: createPieceViewModel)
        createPieceViewController.modalPresentationStyle = .currentContext
        Haptics.main.select()
        self.present(createPieceViewController, animated: true, completion: nil)
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BouncyLayout(style: .subtle))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(PieceCell.self, forCellWithReuseIdentifier: PieceCell.identifier)
        return collectionView
    }
    
    private func makeNoPiecesLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "No pieces yet"
        return label
    }
}

extension ChoosePieceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case PiecesRow.piece(let piece) = viewModel.rows[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieceCell.identifier, for: indexPath) as! PieceCell
            cell.configure(piece: piece)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case PiecesRow.piece(let piece) = viewModel.rows[indexPath.row] {
            rootPractice.focus(piece: piece)
        }
    }
}

extension ChoosePieceViewController: ChoosePieceViewModelDelegate {
    
    @objc func reloadRows() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.noPiecesLabel.isHidden = !self.viewModel.rows.isEmpty
        }
    }
}

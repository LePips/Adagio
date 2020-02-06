//
//  PiecesRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum PiecesRow {
    case piece(Piece)
}

extension PiecesRow {
    
    static func register(collectionView: UICollectionView) {
        collectionView.register(PieceCell.self, forCellWithReuseIdentifier: PieceCell.identifier)
    }
    
    func cell(for path: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        switch self {
        case .piece(let piece):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PieceCell.identifier, for: path) as! PieceCell
            cell.configure(piece: piece)
            return cell
        }
    }
}

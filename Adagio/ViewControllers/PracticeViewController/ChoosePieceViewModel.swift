//
//  ChoosePieceViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/31/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol ChoosePieceViewModelDelegate {
    
    func reloadRows()
}

class ChoosePieceViewModel {
    
    var rows: [PiecesRow] = []
    var pieceSelectedAction: (Piece) -> Void
    var delegate: ChoosePieceViewModelDelegate?
    
    init(pieceSelectedAction: @escaping (Piece) -> Void) {
        self.pieceSelectedAction = pieceSelectedAction
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPieces), name: CoreDataManager.saveNotification, object: nil)
        fetchPieces()
    }
    
    @objc func fetchPieces() {
        let fetchRequest: NSFetchRequest<Piece> = Piece.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        CoreDataManager.main.fetch(request: fetchRequest) { (pieces) in
            self.rows = pieces.compactMap({ PiecesRow.piece($0) })
            self.delegate?.reloadRows()
        }
    }
}

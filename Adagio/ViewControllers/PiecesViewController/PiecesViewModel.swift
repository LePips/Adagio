//
//  PiecesViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData
import SharedPips

protocol PiecesViewModelDelegate {
    
    func reloadRows()
}

class PiecesViewModel {
    
    var rows: [PiecesRow] = []
    var delegate: PiecesViewModelDelegate?
    
    init() {
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

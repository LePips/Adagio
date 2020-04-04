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

protocol PiecesViewModelProtocol {
    
    var rows: [PiecesRow] { get set }
    var delegate: PiecesViewModelDelegate? { get set }
    
    func fetchPieces()
    func deletePiece(path: IndexPath)
}

class PiecesViewModel: PiecesViewModelProtocol {
    
    var _rows: [PiecesRow] = []
    var rows: [PiecesRow] {
        get {
            if !searchQuery.isEmpty {
                return _rows.compactMap { (row) -> PiecesRow? in
                    if case let PiecesRow.piece(piece) = row {
                        return currentSearchScope.scopeContains(query: searchQuery, for: piece) ? row : nil
                    }
                    return nil
                }
            } else {
                return _rows
            }
        }
        set {
            _rows = newValue
        }
    }
    var searchQuery = ""
    var currentSearchScope: PieceSearchScope = .title
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
    
    func deletePiece(path: IndexPath) {
        if case PiecesRow.piece(let piece) = rows[path.row] {
            piece.delete(writeToDisk: true) { (_) in
                self.fetchPieces()
            }
        }
    }
}

enum PieceSearchScope: String {
    case title = "Title"
    case composer = "Composer"
    case instrument = "Instrument"
    
    func scopeContains(query: String, for piece: Piece) -> Bool {
        let lquery = query.lowercased()
        switch self {
        case .title:
            return piece.title.lowercased().contains(lquery)
        case .composer:
            return piece.artist?.lowercased().contains(lquery) ?? false
        case .instrument:
            let instruments = piece.instruments as! Set<Instrument>
            return instruments.reduce("") { (result, instrument) -> String in
                return result + instrument.title
            }.contains(lquery)
        }
    }
    
    static var titles: [String] {
        return [PieceSearchScope.title.rawValue, PieceSearchScope.composer.rawValue]
    }
}

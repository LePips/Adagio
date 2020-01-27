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
    
    static func register(tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PieceCell.self, forCellReuseIdentifier: PieceCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .piece(let piece):
            let cell = tableView.dequeueReusableCell(withIdentifier: PieceCell.identifier, for: path) as! PieceCell
            cell.configure(piece: piece)
            return cell
        }
    }
}

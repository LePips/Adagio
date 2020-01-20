//
//  YouRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum YouRow {
    case subtitle
    case practice(Practice)
}

extension YouRow {
    
    static func buildRows() -> [YouRow] {
        return [.subtitle]
    }
    
    static func register(tableView: UITableView) {
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .subtitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            cell.configure(with: "History")
            return cell
        case .practice(_):
            return UITableViewCell()
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .subtitle:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .practice(_):
            return 0
        }
    }
}

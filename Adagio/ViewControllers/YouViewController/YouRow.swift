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
    
    static func buildRows(practices: [Practice]) -> [YouRow] {
        var rows: [YouRow] = [.subtitle]
        
        rows.append(contentsOf: practices.compactMap({ YouRow.practice($0) }))
        
        return rows
    }
    
    static func register(tableView: UITableView) {
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .subtitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            cell.configure(with: "History")
            return cell
        case .practice(let practice):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: path)
            cell.textLabel?.text = practice.title
            cell.detailTextLabel?.text = "\(practice.startDate)"
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .subtitle:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .practice(_):
            return 50
        }
    }
}

//
//  HomeRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum HomeRow {
    case date
    case subtitle
    case practice(Practice)
}

extension HomeRow {
    
    static func buildRows(practices: [Practice]) -> [HomeRow] {
        var rows: [HomeRow] = [.date]
        
        if !practices.isEmpty {
            rows.append(.subtitle)
            rows.append(contentsOf: practices.compactMap({ HomeRow.practice($0) }))
        }
        
        return rows
    }
    
    static func register(tableView: UITableView) {
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            let dateFormatter = DateFormatter(format: "EEEE, MMM d")
            cell.configure(with: dateFormatter.string(from: Date()))
            return cell
        case .subtitle:
            return UITableViewCell()
        case .practice(_):
            return UITableViewCell()
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .date:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .subtitle:
            return 0
        case .practice(_):
            return 0
        }
    }
}

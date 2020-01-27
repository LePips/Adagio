//
//  EditItemRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum EditItemRow {
    case spacer(CGFloat)
    case subtitle(String)
    case instrument(Instrument)
    case group(Group)
}

extension EditItemRow {
    
    static func register(tableView: UITableView) {
        tableView.register(SpacerCell.self, forCellReuseIdentifier: SpacerCell.identifier)
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
        tableView.register(EditItemCell.self, forCellReuseIdentifier: EditItemCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .spacer(_):
            return tableView.dequeueReusableCell(withIdentifier: SpacerCell.identifier, for: path) as! SpacerCell
        case .subtitle(let subtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            cell.configure(with: subtitle)
            return cell
        case .instrument(let instrument):
            let cell = tableView.dequeueReusableCell(withIdentifier: EditItemCell.identifier, for: path) as! EditItemCell
            let subtitle: String
            if instrument.pieces?.count == 1 {
                subtitle = "1 piece"
            } else {
                subtitle = "\(instrument.pieces?.count ?? 0) pieces"
            }
            cell.configure(title: instrument.title, subtitle: subtitle)
            return cell
        case .group(let group):
            let cell = tableView.dequeueReusableCell(withIdentifier: EditItemCell.identifier, for: path) as! EditItemCell
            let subtitle: String
            if group.pieces?.count == 1 {
                subtitle = "1 piece"
            } else {
                subtitle = "\(group.pieces?.count ?? 0) pieces"
            }
            cell.configure(title: group.title, subtitle: subtitle)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .spacer(let height):
            return height
        case .subtitle(_):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .instrument(_):
            return 80
        case .group(_):
            return 80
        }
    }
}

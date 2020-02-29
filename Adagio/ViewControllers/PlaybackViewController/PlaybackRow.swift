//
//  PlaybackRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/23/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum PlaybackRow {
    case title(TextFieldCellConfiguration)
    case notes(TextFieldCellConfiguration)
}

extension PlaybackRow {
    
    static func register(tableView: UITableView) {
        tableView.register(LargerTextFieldCell.self, forCellReuseIdentifier: LargerTextFieldCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargerTextFieldCell.identifier, for: path) as! LargerTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .notes(let configuration) :
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
            case .title(let configuration):
                return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                    (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 30, weight: .semibold))
            case .notes(let configuration):
                return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                    (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        }
    }
}

//
//  FocusSectionRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/3/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum FocusSectionRow {
    case title(TextFieldCellConfiguration)
    case subtitle
    case notes(TextFieldCellConfiguration)
}

extension FocusSectionRow {
    
    static func register(tableView: UITableView) {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(LargerTextFieldCell.self, forCellReuseIdentifier: LargerTextFieldCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargerTextFieldCell.identifier, for: path) as! LargerTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .subtitle:
            return UITableViewCell()
        case .notes(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        }
    }
}

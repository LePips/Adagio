//
//  EditPieceRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum EditPieceRow {
    case title(TextFieldCellConfiguration)
    case artist(TextFieldCellConfiguration)
    case note(TextFieldCellConfiguration)
    case instruments(SelectionCellConfiguration)
    case groups(SelectionCellConfiguration)
    case segment(SegmentConfiguration)
    case images(ImageSelectionCellConfiguration)
    
    var key: String {
        switch self {
        case .title(_):
            return "title"
        case .artist(_):
            return "artist"
        case .note(_):
            return "note"
        case .instruments(_):
            return "instruments"
        case .groups(_):
            return "groups"
        case .segment:
            return "segment"
        case .images(_):
            return "images"
        }
    }
}

extension EditPieceRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    static func == (lhs: EditPieceRow, rhs: EditPieceRow) -> Bool {
        return lhs.key == rhs.key
    }
}

extension EditPieceRow {
    
    static func register(tableView: UITableView) {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(LargeTextFieldCell.self, forCellReuseIdentifier: LargeTextFieldCell.identifier)
        tableView.register(SelectionCell.self, forCellReuseIdentifier: SelectionCell.identifier)
        tableView.register(SegmentCell.self, forCellReuseIdentifier: SegmentCell.identifier)
        tableView.register(ImageSelectionCell.self, forCellReuseIdentifier: ImageSelectionCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargeTextFieldCell.identifier, for: path) as! LargeTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .artist(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        case .note(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        case .instruments(let configuration), .groups(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectionCell.identifier, for: path) as! SelectionCell
            cell.configure(configuration: configuration)
            return cell
        case .segment(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentCell.identifier, for: path) as! SegmentCell
            cell.configure(configuration: configuration)
            return cell
        case .images(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageSelectionCell.identifier, for: path) as! ImageSelectionCell
            cell.configure(configuration: configuration)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .title(let configuration):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 24, weight: .semibold))
        case .artist(let configuration), .note(let configuration):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        case .instruments(let config):
            var height: CGFloat = 62
            height += max(16, CGFloat(config.items.count) * 16)
            return height
        case .groups(let config):
            var height: CGFloat = 62
            height += max(16, CGFloat(config.items.count) * 16)
            return height
        case .segment(_):
            return 50
        case .images(_):
            return 170
        }
    }
}

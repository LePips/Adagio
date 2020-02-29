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
    case subtitle(String)
    case notes(TextFieldCellConfiguration)
    case radio(RadioCellConfiguration)
    case recording(RecordingCellConfiguration)
    
    var key: String {
        switch self {
        case .title(_):
            return "title"
        case .subtitle:
            return "subtitle"
        case .notes(_):
            return "notes"
        case .radio(_):
            return "radio"
        case .recording(_):
            return "recording"
        }
    }
}

extension FocusSectionRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    static func == (lhs: FocusSectionRow, rhs: FocusSectionRow) -> Bool {
        return lhs.key == rhs.key
    }
}

extension FocusSectionRow {
    
    static func register(tableView: UITableView) {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
        tableView.register(LargerTextFieldCell.self, forCellReuseIdentifier: LargerTextFieldCell.identifier)
        tableView.register(RadioCell.self, forCellReuseIdentifier: RadioCell.identifier)
        tableView.register(RecordingCell.self, forCellReuseIdentifier: RecordingCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargerTextFieldCell.identifier, for: path) as! LargerTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .subtitle(let subtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            cell.configure(with: subtitle)
            return cell
        case .notes(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        case .radio(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: RadioCell.identifier, for: path) as! RadioCell
            cell.configure(with: configuration)
            return cell
        case .recording(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: RecordingCell.identifier, for: path) as! RecordingCell
            cell.configure(with: configuration)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .title(let configuration):
            return 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 30, weight: .semibold))
        case .subtitle:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .notes(let configuration):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        case .radio(_):
            return 50
        case .recording(let configuration):
            var height: CGFloat = 62
            height += max(16, CGFloat(configuration.recordings.filter({ $0.title != "" }).count) * 30)
            return height
        }
    }
}

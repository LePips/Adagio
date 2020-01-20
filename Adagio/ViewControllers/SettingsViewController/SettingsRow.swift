//
//  SettingsRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum SettingsRow {
    case spacer(CGFloat)
    case item(SettingsItemType)
    case switchSetting(SettingsBooleanType)
    case section(SettingsSectionType)
    case feedback(SettingsFeedbackType)
}

extension SettingsRow {
    
    static func register(tableView: UITableView) {
        tableView.register(SpacerCell.self, forCellReuseIdentifier: SpacerCell.identifier)
        tableView.register(SettingsSectionCell.self, forCellReuseIdentifier: SettingsSectionCell.identifier)
        tableView.register(SettingsBoolCell.self, forCellReuseIdentifier: SettingsBoolCell.identifier)
        tableView.register(SettingsItemCell.self, forCellReuseIdentifier: SettingsItemCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .spacer(_):
            return tableView.dequeueReusableCell(withIdentifier: SpacerCell.identifier, for: path) as! SpacerCell
        case .item(let itemType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemCell.identifier, for: path) as! SettingsItemCell
            cell.configure(itemType: itemType)
            return cell
        case .switchSetting(let booleanType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsBoolCell.identifier, for: path) as! SettingsBoolCell
            cell.configure(booleanType: booleanType)
            return cell
        case .section(let sectionType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSectionCell.identifier, for: path) as! SettingsSectionCell
            cell.configure(title: sectionType.title, description: sectionType.description)
            return cell
        case .feedback(let feedbackType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemCell.identifier, for: path) as! SettingsItemCell
            cell.configure(feedbackType: feedbackType)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .spacer(let height):
            return height
        case .item(_), .feedback(_):
            return 50
        case .section(_), .switchSetting(_):
            return "tHeight".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 18, weight: .medium)) +
            "d\nHeight".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 12, weight: .regular)) + 32
        }
    }
}

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
    case title(String)
    case item(SettingsItemType)
    case switchSetting(SettingsBooleanType)
    case section(SettingsSectionType)
    case feedback(SettingsFeedbackType)
    case appIcon(SettingsAppIconType)
    
    case purge
    case setTestData
}

extension SettingsRow {
    
    static func register(tableView: UITableView) {
        tableView.register(SpacerCell.self, forCellReuseIdentifier: SpacerCell.identifier)
        tableView.register(SettingsTitleCell.self, forCellReuseIdentifier: SettingsTitleCell.identifier)
        tableView.register(SettingsSectionCell.self, forCellReuseIdentifier: SettingsSectionCell.identifier)
        tableView.register(SettingsBoolCell.self, forCellReuseIdentifier: SettingsBoolCell.identifier)
        tableView.register(SettingsItemCell.self, forCellReuseIdentifier: SettingsItemCell.identifier)
        tableView.register(SettingsAppIconCell.self, forCellReuseIdentifier: SettingsAppIconCell.identifier)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .spacer(_):
            return tableView.dequeueReusableCell(withIdentifier: SpacerCell.identifier, for: path) as! SpacerCell
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTitleCell.identifier, for: path) as! SettingsTitleCell
            cell.configure(title: title)
            return cell
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
        case .purge:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: path)
            cell.textLabel?.textColor = UIColor.systemRed
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            cell.textLabel?.text = "Purge"
            return cell
        case .setTestData:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: path)
            cell.backgroundColor = .clear
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            cell.textLabel?.text = "Set test data"
            return cell
        case .appIcon(let iconType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAppIconCell.identifier, for: path) as! SettingsAppIconCell
            cell.configure(title: iconType.title, icon: iconType.icon, current: iconType.selected)
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
            "dHeight".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 12, weight: .regular)) + 32
        case .purge, .setTestData:
            return 50
        case .title(_):
            return 40
        case .appIcon(_):
            return 100
        }
    }
}

//
//  PracticeRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum PracticeRow {
    case title(TextFieldCellConfiguration)
    case subtitle
    case notes(TextFieldCellConfiguration)
    case section(Section)
    case addPiece(AddPieceConfiguration)
    case deletePractice(DeletePracticeConfiguration)
    
    var key: String {
        switch self {
        case .title(_):
            return "title"
        case .subtitle:
            return "subtitle"
        case .notes(_):
            return "notes"
        case .section(let section):
            return "\(section)"
        case .addPiece(_):
            return "add piece"
        case .deletePractice(_):
            return "delete practice"
        }
    }
}

extension PracticeRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    static func == (lhs: PracticeRow, rhs: PracticeRow) -> Bool {
        return lhs.key == rhs.key
    }
}

extension PracticeRow {
    
    static func register(tableView: UITableView) {
        tableView.register(LargerTextFieldCell.self, forCellReuseIdentifier: LargerTextFieldCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(HomeSubtitleCell.self, forCellReuseIdentifier: HomeSubtitleCell.identifier)
        tableView.register(AddPieceCell.self, forCellReuseIdentifier: AddPieceCell.identifier)
        tableView.register(DeletePracticeCell.self, forCellReuseIdentifier: DeletePracticeCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargerTextFieldCell.identifier, for: path) as! LargerTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .subtitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeSubtitleCell.identifier, for: path) as! HomeSubtitleCell
            let dateFormatter = DateFormatter(format: "EEEE, MMM d")
            cell.configure(with: dateFormatter.string(from: Date()))
            return cell
        case .notes(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        case .section(_):
            return UITableViewCell()
        case .addPiece(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: AddPieceCell.identifier, for: path) as! AddPieceCell
            cell.configure(configuration: configuration)
            return cell
        case .deletePractice(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: DeletePracticeCell.identifier, for: path) as! DeletePracticeCell
            cell.configure(configuration: configuration)
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
        case .section(_):
            return 0
        case .addPiece(_):
            return 100
        case .deletePractice(_):
            return 50
        }
    }
}

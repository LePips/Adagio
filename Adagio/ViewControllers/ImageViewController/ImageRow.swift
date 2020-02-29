//
//  ImageRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum ImageRow {
    case image(UIImage)
    case title(TextFieldCellConfiguration)
    case note(TextFieldCellConfiguration)
    case spacer(CGFloat)
    
    var key: String {
        switch self {
        case .image(_):
            return "image"
        case .title(_):
            return "title"
        case .note(_):
            return "note"
        case .spacer(_):
            return "spacer"
        }
    }
}

extension ImageRow: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    static func == (lhs: ImageRow, rhs: ImageRow) -> Bool {
        return lhs.key == rhs.key
    }
}

extension ImageRow {
    
    static func register(tableView: UITableView) {
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.identifier)
        tableView.register(LargeTextFieldCell.self, forCellReuseIdentifier: LargeTextFieldCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(SpacerCell.self, forCellReuseIdentifier: SpacerCell.identifier)
    }
    
    func cell(for path: IndexPath, in tableView: UITableView) -> UITableViewCell {
        switch self {
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: path) as! ImageCell
            cell.configure(image: image)
            return cell
        case .title(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: LargeTextFieldCell.identifier, for: path) as! LargeTextFieldCell
            cell.configure(with: configuration)
            return cell
        case .note(let configuration):
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: path) as! TextFieldCell
            cell.configure(with: configuration)
            return cell
        case .spacer(_):
            return tableView.dequeueReusableCell(withIdentifier: SpacerCell.identifier, for: path) as! SpacerCell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .image(let image):
            let scale = UIScreen.main.bounds.width / image.size.width
            return image.size.height * scale
        case .title(let configuration):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 24, weight: .semibold))
        case .note(let configuration):
            return "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium)) + 41 +
                (configuration.text ?? "").height(withConstrainedWidth: UIScreen.main.bounds.width - 34, font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        case .spacer(let height):
            return height
        }
    }
}

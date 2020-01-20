//
//  SettingsViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

protocol SettingsViewModelDelegate {
    
    func reloadRows()
    
    func pushViewController(_ viewController: UIViewController)
    
    func presentViewController(_ viewController: UIViewController)
}

protocol SettingsViewModelProtocol: class {
    
    var title: String { get set }
    var rows: [SettingsRow] { get set }
    var delegate: SettingsViewModelDelegate? { get set }
    
    func selectRowAt(indexPath: IndexPath)
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    var title: String
    var rows: [SettingsRow] = []
    var delegate: SettingsViewModelDelegate?
    
    init(title: String, rows: [SettingsRow]) {
        self.title = title
        self.rows = [.spacer(30)]
        self.rows.append(contentsOf: rows)
        delegate?.reloadRows()
    }
    
    func selectRowAt(indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .section(let sectionType):
            delegate?.pushViewController(sectionType.viewController)
        case .item(let itemType):
            delegate?.pushViewController(itemType.viewController)
        case .switchSetting: ()
        case .spacer(_): ()
        case .feedback(let feedbackType):
            switch feedbackType {
            case .appStoreReview: ()
            case .requestFeature:
                guard let feedbackViewController = feedbackType.viewController else { assertionFailure(); return }
                delegate?.presentViewController(feedbackViewController)
            }
        }
    }
}

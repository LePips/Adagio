//
//  SettingsType.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

// MARK: - SettingsSectionType
enum SettingsSectionType: CaseIterable {
    case defaults
    case sounds
    case editItems
    case feedback
    
    var title: String {
        switch self {
        case .defaults:
            return "Defaults"
        case .sounds:
            return "Sounds"
        case .editItems:
            return "Edit Items"
        case .feedback:
            return "Feedback"
        }
    }
    
    var description: String {
        switch self {
        case .defaults:
            return "Personalize and streamline your practices"
        case .sounds:
            return "Edit preferences for sounds and haptic feedback"
        case .editItems:
            return "Edit items like instruments and groups"
        case .feedback:
            return "Leave feedback and request new features"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .defaults:
            let defaultsRows = SettingsBooleanType.allCases.compactMap({ SettingsRow.switchSetting($0) })
            let defaultsViewModel = SettingsViewModel(title: "Defaults", rows: defaultsRows)
            return SettingsViewController(viewModel: defaultsViewModel)
        case .sounds:
            let soundsViewModel = SettingsViewModel(title: "Sounds", rows: [])
            return SettingsViewController(viewModel: soundsViewModel)
        case .editItems:
            let editItemsViewModel = SettingsViewModel(title: "Edit Items", rows: [.item(.instruments), .item(.groups)])
            return SettingsViewController(viewModel: editItemsViewModel)
        case .feedback:
            let feedbackViewModel = SettingsViewModel(title: "Feedback", rows: [.feedback(.appStoreReview), .feedback(.requestFeature)])
            return SettingsViewController(viewModel: feedbackViewModel)
        }
    }
}

// MARK: - SettingsBooleanType
enum SettingsBooleanType: CaseIterable {
    case focusPiece
    case warmUpToTop
    case showPlaceholders
    
    var title: String {
        switch self {
        case .focusPiece:
            return "Focus Piece When Added"
        case .warmUpToTop:
            return "Move Warm Up To Top"
        case .showPlaceholders:
            return "Show Placeholders"
        }
    }
    
    var description: String {
        switch self {
        case .focusPiece:
            return "Focus a piece upon being added to a practice"
        case .warmUpToTop:
            return "Moves a piece to the top of the list of pieces in a practice"
        case .showPlaceholders:
            return "Shows placeholders for all empty textfields"
        }
    }
    
    var isOn: Bool {
        switch self {
        case .focusPiece:
            return UserDefaults.standard.focusPiece
        case .warmUpToTop:
            return UserDefaults.standard.warmUpToTop
        case .showPlaceholders:
            return UserDefaults.standard.showPlaceholders
        }
    }
    
    func switchAction() {
        switch self {
        case .focusPiece:
            UserDefaults.standard.focusPiece = !UserDefaults.standard.focusPiece
        case .warmUpToTop:
            UserDefaults.standard.warmUpToTop = !UserDefaults.standard.warmUpToTop
        case .showPlaceholders:
            UserDefaults.standard.showPlaceholders = !UserDefaults.standard.showPlaceholders
        }
    }
}

// MARK: - SettingsItemType
enum SettingsItemType {
    case instruments
    case groups
    
    var title: String {
        switch self {
        case .instruments:
            return "Instruments"
        case .groups:
            return "Groups"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .instruments:
            let editInstrumentsViewModel = EditInstrumentsViewModel()
            return EditItemsViewController(viewModel: editInstrumentsViewModel)
        case .groups:
            let editGroupsViewModel = EditGroupsViewModel()
            return EditItemsViewController(viewModel: editGroupsViewModel)
        }
    }
}

// MARK: - SettingsFeedbackType
enum SettingsFeedbackType {
    case appStoreReview
    case requestFeature
    
    var title: String {
        switch self {
        case .appStoreReview:
            return "Leave App Store Review"
        case .requestFeature:
            return "Request Feature"
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .appStoreReview:
            return nil
        case .requestFeature:
            let requestFeature = RequestFeatureViewModel()
            return RequestFeatureRootViewController(viewModel: requestFeature)
        }
    }
}

// MARK: - UserDefaults
extension UserDefaults {
    
    var focusPiece: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "focusPiece")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "focusPiece")
        }
    }
    
    var warmUpToTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "warmUpToTop")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "warmUpToTop")
        }
    }
    
    var showPlaceholders: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "showPlaceholders")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "showPlaceholders")
        }
    }
}

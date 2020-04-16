//
//  SettingsType.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum SecondSettingSectionType: CaseIterable {
    
    static func buildRows() -> [SettingsRow] {
        var rows: [SettingsRow] = []
        rows.append(.spacer(10))
        rows.append(.title("Items"))
        rows.append(.spacer(3))
        rows.append(.item(.instruments))
        rows.append(.item(.groups))
        
        rows.append(.spacer(10))
        rows.append(.title("Vibrations"))
        rows.append(.spacer(3))
        rows.append(.switchSetting(.vibrationsEnabled))
        
        rows.append(.spacer(10))
        rows.append(.feedback(.about))
        rows.append(.feedback(.appIcon))
        rows.append(.feedback(.requestFeature))
        rows.append(.feedback(.appStoreReview))
        
        return rows
    }
}

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
    
    case vibrationsEnabled
    
    var title: String {
        switch self {
        case .focusPiece:
            return "Focus Piece When Added"
        case .warmUpToTop:
            return "Move Warm Up To Top"
        case .showPlaceholders:
            return "Show Placeholders"
        case .vibrationsEnabled:
            return "Enabled"
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
        case .vibrationsEnabled:
            return " "
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
        case .vibrationsEnabled:
            return UserDefaults.standard.vibrationsEnabled
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
        case .vibrationsEnabled:
            UserDefaults.standard.vibrationsEnabled = !UserDefaults.standard.vibrationsEnabled
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
    case about
    case appStoreReview
    case requestFeature
    case appIcon
    
    var title: String {
        switch self {
        case .about:
            return "About"
        case .appStoreReview:
            return "Leave App Store Review"
        case .requestFeature:
            return "Request a Feature"
        case .appIcon:
            return "Change App Icon"
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .about:
            return nil
        case .appStoreReview:
            return nil
        case .requestFeature:
            let requestFeature = RequestFeatureViewModel()
            return RequestFeatureRootViewController(viewModel: requestFeature)
        case .appIcon:
            let appIconViewModel = SettingsViewModel(title: "App Icon", rows: [.appIcon(.light), .appIcon(.dark)])
            return SettingsViewController(viewModel: appIconViewModel)
        }
    }
}

// MARK: - SettingsAppIconType
enum SettingsAppIconType {
    case light
    case dark
    
    var title: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .light:
            return UIImage.AppIcon.light
        case .dark:
            return UIImage.AppIcon.dark
        }
    }
    
    func selectedAction() {
        switch self {
        case .light:
            UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
        case .dark:
            UIApplication.shared.setAlternateIconName("darkAppIcon", completionHandler: nil)
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
    
    var vibrationsEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "vibrationsEnabled")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "vibrationsEnabled")
        }
    }
    
    var firstLaunch: Bool {
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            UserDefaults.standard.set(true, forKey: "firstLaunch")
            return false
        } else {
            return true
        }
    }
}

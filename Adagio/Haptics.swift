//
//  Haptics.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/1/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

struct Haptics {
    
    static let main = Haptics()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let feedbackGenerator = UIFeedbackGenerator()
    
    private init() {
        prepare()
    }
    
    private func prepare() {
        feedbackGenerator.prepare()
    }
    
    func success() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
        prepare()
    }
    
    func error() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        notificationGenerator.notificationOccurred(.error)
        prepare()
    }
    
    func select() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        selectionGenerator.selectionChanged()
        prepare()
    }
    
    func light() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        lightImpactGenerator.impactOccurred()
        prepare()
    }
    
    func medium() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        mediumImpactGenerator.impactOccurred()
        prepare()
    }
    
    func heavy() {
        guard UserDefaults.standard.vibrationsEnabled else { return }
        heavyImpactGenerator.impactOccurred()
        prepare()
    }
}

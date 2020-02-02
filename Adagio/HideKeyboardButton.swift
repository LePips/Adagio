//
//  HideKeyboardButton.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/1/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class HideKeyboardButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
//        let configuration = UIImage.SymbolConfiguration(
        self.setImage(UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: nil), for: .normal)
        self.tintColor = UIColor.Adagio.textColor
        self.backgroundColor = UIColor.tertiarySystemBackground
        self.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

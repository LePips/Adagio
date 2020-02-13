//
//  RadioCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/10/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

struct RadioCellConfiguration {
    
    var title: String
    var selected: Bool
    var selectedAction: (Bool) -> Void
    
}

class RadioCell: AdagioCell, Selectable {
    
    private lazy var radioButton = makeRadioButton()
    private lazy var titleLabel = makeTitleLabel()
    private var radioSelected = false
    private var configSelectedAction: ((Bool) -> Void)?
    
    func configure(with config: RadioCellConfiguration) {
        titleLabel.text = config.title
        
        radioSelected = config.selected
        let radioConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        if config.selected {
            radioButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: radioConfig), for: .normal)
        } else {
            radioButton.setImage(UIImage(systemName: "square", withConfiguration: radioConfig), for: .normal)
        }
        
        self.configSelectedAction = config.selectedAction
    }
    
    func select() {
        radioSelectedAction()
    }
    
    func deselect() {
        
    }
    
    override func setupSubviews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor ⩵ contentView.centerYAnchor,
            radioButton.leftAnchor ⩵ contentView.leftAnchor + 17,
            radioButton.heightAnchor ⩵ 30,
            radioButton.widthAnchor ⩵ 30        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor ⩵ contentView.centerYAnchor,
            titleLabel.leftAnchor ⩵ radioButton.rightAnchor + 10
        ])
    }
    
    private func makeRadioButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.addTarget(self, action: #selector(radioSelectedAction), for: .touchUpInside)
        button.tintColor = UIColor.systemOrange
        return button
    }
    
    @objc private func radioSelectedAction() {
        radioSelected = !radioSelected
        let radioConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        if radioSelected {
            radioButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: radioConfig), for: .normal)
        } else {
            radioButton.setImage(UIImage(systemName: "square", withConfiguration: radioConfig), for: .normal)
        }
        
        configSelectedAction?(radioSelected)
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

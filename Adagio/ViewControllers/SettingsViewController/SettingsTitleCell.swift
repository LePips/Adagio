//
//  SettingsTitleCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 4/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SettingsTitleCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor ⩵ contentView.centerYAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

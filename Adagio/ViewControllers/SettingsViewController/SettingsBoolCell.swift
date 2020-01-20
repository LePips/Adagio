//
//  SettingsBoolCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SettingsBoolCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var separatorView = makeSeparatorView()
    private lazy var switchView = makeSwitchView()
    private var booleanType: SettingsBooleanType?
    
    func configure(booleanType: SettingsBooleanType) {
        self.booleanType = booleanType
        titleLabel.text = booleanType.title
        descriptionLabel.text = booleanType.description
        switchView.isOn = booleanType.isOn
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(switchView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor ⩵ titleLabel.bottomAnchor + 5,
            descriptionLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            descriptionLabel.rightAnchor ⩵ contentView.centerXAnchor
        ])
        NSLayoutConstraint.activate([
            separatorView.topAnchor ⩵ descriptionLabel.bottomAnchor + 10,
            separatorView.heightAnchor ⩵ 1,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            switchView.rightAnchor ⩵ contentView.rightAnchor - 17,
            switchView.topAnchor ⩵ contentView.topAnchor + 15
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 2
        return label
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeSwitchView() -> UISwitch {
        let switchView = UISwitch.forAutoLayout()
        switchView.addTarget(self, action: #selector(switchSwitched), for: .valueChanged)
        return switchView
    }
    
    @objc private func switchSwitched() {
        booleanType?.switchAction()
    }
}

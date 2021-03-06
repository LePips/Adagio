//
//  SettingsItemCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SettingsItemCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var separatorView = makeSeparatorView()
    private lazy var indicatorView = makeIndicatorView()
    
    func configure(itemType: SettingsItemType) {
        titleLabel.text = itemType.title
    }
    
    func configure(feedbackType: SettingsFeedbackType) {
        titleLabel.text = feedbackType.title
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(indicatorView)
        separatorView.alpha = 0
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            titleLabel.topAnchor ⩵ contentView.topAnchor
        ])
        NSLayoutConstraint.activate([
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.bottomAnchor ⩵ titleLabel.bottomAnchor + 10,
            separatorView.heightAnchor ⩵ 1
        ])
        NSLayoutConstraint.activate([
            indicatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            indicatorView.centerYAnchor ⩵ titleLabel.centerYAnchor
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeIndicatorView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .light)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }
}

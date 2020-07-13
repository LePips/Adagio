//
//  SettingsAppIconCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 4/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SettingsAppIconCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var separatorView = makeSeparatorView()
    private lazy var iconImageView = makeIconImageView()
    private lazy var checkMarkView = makeCheckMarkView()
    
    func configure(title: String, icon: UIImage, current: Bool) {
        titleLabel.text = title
        iconImageView.image = icon
        checkMarkView.isHidden = !current
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(checkMarkView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            titleLabel.centerYAnchor ⩵ iconImageView.centerYAnchor
        ])
        NSLayoutConstraint.activate([
            iconImageView.topAnchor ⩵ contentView.topAnchor + 10,
            iconImageView.rightAnchor ⩵ contentView.rightAnchor - 17,
            iconImageView.heightAnchor ⩵ 80,
            iconImageView.widthAnchor ⩵ 80
        ])
        NSLayoutConstraint.activate([
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.bottomAnchor ⩵ iconImageView.bottomAnchor + 10,
            separatorView.heightAnchor ⩵ 1
        ])
        NSLayoutConstraint.activate([
            checkMarkView.centerYAnchor ⩵ titleLabel.centerYAnchor,
            checkMarkView.rightAnchor ⩵ iconImageView.leftAnchor - 17
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
    
    private func makeIconImageView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func makeCheckMarkView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: config)
        imageView.tintColor = UIColor.Adagio.textColor
        return imageView
    }
}

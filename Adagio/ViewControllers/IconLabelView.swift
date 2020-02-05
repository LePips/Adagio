//
//  IconLabelView.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/4/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class IconLabelView: BasicView {
    
    private lazy var iconView = makeIconView()
    private lazy var titleLabel = makeTitleLabel()
    
    func configure(iconName: String, title: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        iconView.image = icon
        
        titleLabel.text = title
    }
    
    override func setupSubviews() {
        addSubview(iconView)
        addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            iconView.leftAnchor ⩵ leftAnchor,
            iconView.centerYAnchor ⩵ centerYAnchor
        ])
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ iconView.rightAnchor + 5,
            titleLabel.centerYAnchor ⩵ centerYAnchor
        ])
    }
    
    private func makeIconView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        imageView.tintColor = UIColor.Adagio.textColor
        return imageView
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

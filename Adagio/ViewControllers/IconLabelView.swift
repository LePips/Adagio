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
    
    func configure(iconName: String, title: String, imageTintColor: UIColor = UIColor.Adagio.textColor) {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let icon = UIImage(systemName: iconName, withConfiguration: config)
        iconView.image = icon
        
        iconView.tintColor = imageTintColor
        
        titleLabel.text = title
        
        NSLayoutConstraint.activate([
            self.widthAnchor ⩵ "X \(title)".width(withConstrainedHeight: 50, font: UIFont.systemFont(ofSize: 14, weight: .medium))
        ])
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
        return UIImageView.forAutoLayout()
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

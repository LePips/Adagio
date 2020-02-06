//
//  SectionView.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/5/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SectionView: BasicView {
    
    private lazy var titleLabel = makeTitleLabel()
    
    func configure(section: Section) {
        titleLabel.text = section.title
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor ⩵ centerYAnchor,
            titleLabel.leftAnchor ⩵ leftAnchor
        ])
        NSLayoutConstraint.activate([
            heightAnchor ⩵ "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium))
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

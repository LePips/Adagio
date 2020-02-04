//
//  HomeSubtitleCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class HomeSubtitleCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    
    func configure(with text: String) {
        titleLabel.text = text
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            titleLabel.bottomAnchor ⩵ contentView.bottomAnchor
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        return label
    }
}

class CollectionSubtitleCell: BasicCollectionViewCell {
    
    private lazy var titleLabel = makeTitleLabel()
    
    func configure(with text: String) {
        titleLabel.text = text
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            titleLabel.bottomAnchor ⩵ contentView.bottomAnchor
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        return label
    }
}

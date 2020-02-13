//
//  PracticeSectionCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/7/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PracticeSectionCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var iconStackView = makeIconStackView()
    
    func configure(section: Section) {
        titleLabel.text = section.title
        
        // Note
        if let _ = section.note {
            let notesView = IconLabelView.forAutoLayout()
            notesView.configure(iconName: "text.alignleft", title: "Notes")
            iconStackView.addArrangedSubview(notesView)
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconStackView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            iconStackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            iconStackView.leftAnchor ⩵ contentView.leftAnchor + 17,
            iconStackView.heightAnchor ⩵ 20
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeIconStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }
}

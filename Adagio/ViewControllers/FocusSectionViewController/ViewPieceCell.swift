//
//  ViewPieceCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/29/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

struct ViewPieceCellConfiguration {
    
    var selectedAction: () -> Void
}

class ViewPieceCell: AdagioCell, Selectable {
    
    private lazy var titleLabel = makeTitleLabel()
    
    private var configuration: ViewPieceCellConfiguration?
    
    func configure(with configuration: ViewPieceCellConfiguration) {
        self.configuration = configuration
    }
    
    func select() {
        configuration?.selectedAction()
    }
    
    func deselect() {
        
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor ⩵ leftAnchor + 17,
            titleLabel.centerYAnchor ⩵ contentView.centerYAnchor
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.textColor = UIColor.systemBlue
        label.text = "View Piece"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }
}

//
//  EditItemCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class EditItemCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var piecesView = makePiecesView()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var separatorView = makeSeparatorView()
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(piecesView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(separatorView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            piecesView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            piecesView.leftAnchor ⩵ titleLabel.leftAnchor
        ])
        NSLayoutConstraint.activate([
            subtitleLabel.leftAnchor ⩵ piecesView.rightAnchor + 5,
            subtitleLabel.centerYAnchor ⩵ piecesView.centerYAnchor
        ])
        NSLayoutConstraint.activate([
            separatorView.topAnchor ⩵ subtitleLabel.bottomAnchor + 10,
            separatorView.heightAnchor ⩵ 1,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makePiecesView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let configuration = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let piecesView = UIImage(named: "doc.music.filled")?.applyingSymbolConfiguration(configuration)
        imageView.tintColor = UIColor.secondaryLabel
        imageView.image = piecesView
        return imageView
    }
    
    private func makeSubtitleLabel() -> UILabel {
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
}

//
//  PieceCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PieceCell: BasicCollectionViewCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var instrumentsLabel = makeInstrumentsLabel()
    private lazy var separatorView = makeSeparatorView()
    private lazy var indicatorView = makeIndicatorView()
    
    func configure(piece: Piece) {
        titleLabel.text = piece.title
        let instruments: [Instrument] = piece.instruments?.allObjects.compactMap({ $0 as? Instrument }) ?? []
        
        if !instruments.isEmpty {
            instrumentsLabel.text = instruments.compactMap({ $0.title }).reduce("", { (result, instrument) -> String in
                return result + "\(instrument), "
            })
            
            instrumentsLabel.text?.removeLast()
        } else {
            instrumentsLabel.text = " "
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(instrumentsLabel)
        contentView.addSubview(separatorView)
//        contentView.addSubview(indicatorView)
        backgroundColor = .clear
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            instrumentsLabel.topAnchor ⩵ titleLabel.bottomAnchor + 5,
            instrumentsLabel.leftAnchor ⩵ contentView.leftAnchor + 17,
            instrumentsLabel.rightAnchor ⩵ contentView.centerXAnchor
        ])
        NSLayoutConstraint.activate([
            separatorView.topAnchor ⩵ instrumentsLabel.bottomAnchor + 10,
            separatorView.heightAnchor ⩵ 1,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17
        ])
//        NSLayoutConstraint.activate([
//            indicatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
//            indicatorView.topAnchor ⩵ contentView.topAnchor + 15
//        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeInstrumentsLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeIndicatorView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.tintColor = UIColor.secondaryLabel
        return imageView
    }
}

//
//  ImageSelectionCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

struct ImageSelectionCellConfiguration {
    
    var images: [Image]
    var addAction: () -> Void
    var selectedAction: (Image) -> Void
    var editing: Bool
}

class ImageSelectionCell: AdagioCell, Editable {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var addButton = makeAddButton()
    private lazy var imageStackView = makeImageStackView()
    private lazy var separatorView = makeSeparatorView()
    private lazy var noneLabel = makeNoneLabel()
    
    private var configuration: ImageSelectionCellConfiguration?
    
    func configure(configuration: ImageSelectionCellConfiguration) {
        self.configuration = configuration
        
        for subview in imageStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        // Images
        for image in configuration.images {
            let imageView = ImageView.forAutoLayout()
            imageView.configure(image: image, delegate: self)
            imageStackView.addArrangedSubview(imageView)
        }
        
        self.noneLabel.alpha = !configuration.editing && imageStackView.arrangedSubviews.isEmpty ? 1 : 0
        self.separatorView.alpha = configuration.editing ? 1 : 0
        self.addButton.alpha = configuration.editing ? 1 : 0
    }
    
    override var isEditing: Bool {
        didSet {
            if isEditing {
                UIView.animate(withDuration: 0.3) {
                    self.addButton.alpha = 1
                    self.separatorView.alpha = 1
                    
                    self.noneLabel.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.addButton.alpha = 0
                    self.separatorView.alpha = 0
                    
                    self.noneLabel.alpha = self.imageStackView.arrangedSubviews.isEmpty ? 1 : 0
                }
            }
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(imageStackView)
        contentView.addSubview(separatorView)
        contentView.addSubview(noneLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor + 10,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            addButton.centerYAnchor ⩵ titleLabel.centerYAnchor,
            addButton.rightAnchor ⩵ contentView.rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            imageStackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            imageStackView.leftAnchor ⩵ contentView.leftAnchor + 17,
            imageStackView.heightAnchor ⩵ 140
        ])
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor ⩵ contentView.bottomAnchor - 10,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.heightAnchor ⩵ 1
        ])
        NSLayoutConstraint.activate([
            noneLabel.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            noneLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        label.text = "Images"
        return label
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(addSelected), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Add Image", for: .normal)
        return button
    }
    
    @objc private func addSelected() {
        configuration?.addAction()
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeNoneLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.tertiaryLabel
        label.text = "None"
        return label
    }
    
    private func makeImageStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        return stackView
    }
}

extension ImageSelectionCell: ImageViewDelegate {
    
    func didSelect(_ imageView: ImageView, with image: Image) {
        configuration?.selectedAction(image)
    }
}

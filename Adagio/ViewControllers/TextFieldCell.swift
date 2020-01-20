//
//  TextFieldCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class TextFieldCellConfiguration: Hashable {

    var title: String
    var required: Bool
    var text: String?
    var textAction: (String) -> Void
    var allowNewLines: Bool
    
    init(title: String, required: Bool, text: String?, textAction: @escaping (String) -> Void, allowNewLines: Bool) {
        self.title = title
        self.required = required
        self.text = text
        self.textAction = textAction
        self.allowNewLines = allowNewLines
    }
    
    static func == (lhs: TextFieldCellConfiguration, rhs: TextFieldCellConfiguration) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
    }
    
    func setText(_ text: String) {
        self.text = text
        textAction(text)
    }
}

// MARK: - TextFieldcell
class TextFieldCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var requiredView = makeRequiredView()
    fileprivate lazy var textView = makeTextView()
    private lazy var separatorView = makeSeparatorView()
    private var configuration: TextFieldCellConfiguration?
    
    func configure(with configuration: TextFieldCellConfiguration) {
        titleLabel.text = configuration.title
        textView.text = configuration.text ?? ""
        requiredView.isHidden = !configuration.required
        self.configuration = configuration
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(requiredView)
        contentView.addSubview(textView)
        contentView.addSubview(separatorView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
            titleLabel.leftAnchor ⩵ contentView.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            requiredView.centerYAnchor ⩵ titleLabel.centerYAnchor,
            requiredView.leftAnchor ⩵ titleLabel.rightAnchor + 5
        ])
        NSLayoutConstraint.activate([
            textView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            textView.leftAnchor ⩵ contentView.leftAnchor + 17,
            textView.rightAnchor ⩵ contentView.rightAnchor - 17,
            textView.bottomAnchor ⩵ separatorView.topAnchor - 10
        ])
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor ⩵ contentView.bottomAnchor - 20,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.heightAnchor ⩵ 1
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeRequiredView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let starImage = UIImage(systemName: "staroflife.fill", withConfiguration: configuration)
        imageView.tintColor = UIColor.systemPink
        imageView.image = starImage
        return imageView
    }
    
    private func makeTextView() -> UITextView {
        let textView = UITextView.forAutoLayout()
        textView.removePadding()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = UIColor.Adagio.textColor
        textView.delegate = self
        textView.isScrollEnabled = false
        
        return textView
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
}

extension TextFieldCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        configuration?.setText(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        return configuration?.allowNewLines ?? true
    }
}

// MARK: - LargeTextFieldCell
class LargeTextFieldCell: TextFieldCell {
    
    override func setupSubviews() {
        super.setupSubviews()
        textView.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
}
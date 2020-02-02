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
    var editing: Bool
    var returnKeyType: UIReturnKeyType
    var returnAction: (UITextView) -> Void
    var textAutocapitalizationType: UITextAutocapitalizationType
    
    init(title: String,
         required: Bool,
         text: String?,
         textAction: @escaping (String) -> Void,
         allowNewLines: Bool,
         editing: Bool = true,
         returnKeyType: UIReturnKeyType = .done,
         returnAction: @escaping (UITextView) -> Void = { textView in textView.resignFirstResponder()},
         textAutocapitalizationType: UITextAutocapitalizationType = .none
    ) {
        self.title = title
        self.required = required
        self.text = text
        self.textAction = textAction
        self.allowNewLines = allowNewLines
        self.editing = editing
        self.returnKeyType = returnKeyType
        self.returnAction = returnAction
        self.textAutocapitalizationType = textAutocapitalizationType
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
class TextFieldCell: AdagioCell, Selectable, Verifiable, Editable {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var requiredView = makeRequiredView()
    fileprivate lazy var textView = makeTextView()
    fileprivate lazy var separatorView = makeSeparatorView()
    private lazy var invalidView = makeInvalidView()
    private lazy var noneLabel = makeNoneLabel()
    private var configuration: TextFieldCellConfiguration?
    
    override var isEditing: Bool {
        didSet {
            self.textView.isEditable = isEditing
            if isEditing {
                UIView.animate(withDuration: 0.2) {
                    self.separatorView.alpha = 1
                    self.requiredView.alpha = 1
                    
                    self.noneLabel.alpha = 0
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.separatorView.alpha = 0
                    self.requiredView.alpha = 0
                    
                    self.noneLabel.alpha = self.textView.text.isEmpty ? 1 : 0
                }
                self.textView.resignFirstResponder()
            }
        }
    }
    
    func configure(with configuration: TextFieldCellConfiguration) {
        titleLabel.text = configuration.title
        textView.text = configuration.text ?? ""
        textView.returnKeyType = configuration.returnKeyType
        textView.autocapitalizationType = configuration.textAutocapitalizationType
        requiredView.isHidden = !configuration.required
        self.configuration = configuration
        self.isEditing = configuration.editing
        
        self.noneLabel.alpha = !configuration.editing && textView.text.isEmpty ? 1 : 0
    }
    
    func select() {
        textView.becomeFirstResponder()
    }
    
    func deselect() {
        textView.resignFirstResponder()
    }
    
    var isValid: Bool {
        guard let configuration = configuration, configuration.required else { return true }
        return !textView.text.isEmpty
    }
    
    func setInvalid() {
        invalidView.alpha = 1
        separatorView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.invalidView.alpha = 0
            self.separatorView.alpha = 1
        }, completion: nil)
    }
    
    func setValid() {
        
    }
    
    override func setupSubviews() {
        contentView.addSubview(invalidView)
        invalidView.alpha = 0
        contentView.addSubview(titleLabel)
        contentView.addSubview(requiredView)
        contentView.addSubview(textView)
        contentView.addSubview(separatorView)
        contentView.addSubview(noneLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor + 10,
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
            separatorView.bottomAnchor ⩵ contentView.bottomAnchor - 10,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.heightAnchor ⩵ 1
        ])
        NSLayoutConstraint.activate([
            invalidView.topAnchor ⩵ contentView.topAnchor,
            invalidView.bottomAnchor ⩵ separatorView.bottomAnchor,
            invalidView.leftAnchor ⩵ contentView.leftAnchor,
            invalidView.rightAnchor ⩵ contentView.rightAnchor
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
        textView.backgroundColor = .clear
        return textView
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeInvalidView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.25)
        return view
    }
    
    private func makeNoneLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.tertiaryLabel
        label.text = "None"
        return label
    }
}

extension TextFieldCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        configuration?.setText(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n" else { return true }
        configuration?.returnAction(textView)
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

// MARK: - LargerTextFieldCell
class LargerTextFieldCell: TextFieldCell {
    
    override func setupSubviews() {
        super.setupSubviews()
        textView.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.separatorView.isHidden = true
    }
}

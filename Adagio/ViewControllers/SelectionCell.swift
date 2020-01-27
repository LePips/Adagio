//
//  SelectionCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import UIKit
import SharedPips

class SelectionCellConfiguration {
    
    var title: String
    var buttonTitle: String
    var items: [String]
    var selectionAction: () -> Void
    var editing: Bool
    
    init(title: String, buttonTitle: String, items: [String], selectionAction: @escaping () -> Void, editing: Bool = true) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.items = items
        self.selectionAction = selectionAction
        self.editing = editing
    }
    
    func set(items: [String]) {
        self.items = items
    }
}

class SelectionCell: AdagioCell, Editable {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var addButton = makeAddButton()
    private lazy var stackView = makeStackView()
    private lazy var separatorView = makeSeparatorView()
    private lazy var noneLabel = makeNoneLabel()
    private var configuration: SelectionCellConfiguration?
    
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
                    
                    self.noneLabel.alpha = self.stackView.arrangedSubviews.isEmpty ? 1 : 0
                }
            }
        }
    }
    
    func configure(configuration: SelectionCellConfiguration) {
        titleLabel.text = configuration.title
        addButton.setTitle(configuration.buttonTitle, for: .normal)
        self.configuration = configuration
        
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for item in configuration.items {
            let itemLabel = UILabel.forAutoLayout()
            itemLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            itemLabel.textColor = UIColor.Adagio.textColor
            itemLabel.text = item
            
            stackView.addArrangedSubview(itemLabel)
        }
        
        self.noneLabel.alpha = !configuration.editing && stackView.arrangedSubviews.isEmpty ? 1 : 0
        self.separatorView.alpha = configuration.editing ? 1 : 0
        self.addButton.alpha = configuration.editing ? 1 : 0
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(stackView)
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
            stackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            stackView.leftAnchor ⩵ contentView.leftAnchor + 17
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
        return label
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(addSelected), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }
    
    @objc private func addSelected() {
        configuration?.selectionAction()
    }
    
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .vertical
        return stackView
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
}

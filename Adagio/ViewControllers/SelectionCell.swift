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
    
    init(title: String, buttonTitle: String, items: [String], selectionAction: @escaping () -> Void) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.items = items
        self.selectionAction = selectionAction
    }
    
    func set(items: [String]) {
        self.items = items
    }
}

class SelectionCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var addButton = makeAddButton()
    private lazy var stackView = makeStackView()
    private lazy var separatorView = makeSeparatorView()
    private var configuration: SelectionCellConfiguration?
    
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
    }
    
    override func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ contentView.topAnchor,
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
}

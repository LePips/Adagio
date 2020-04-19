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
    private lazy var separatorView = makeSeparatorView()
    
    func configure(section: Section) {
        titleLabel.text = section.title
        
        for subview in iconStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        // Warm up
        if section.warmUp {
            let warmUpView = IconLabelView.forAutoLayout()
            warmUpView.configure(iconName: "w.square.fill", title: "Warm Up", imageTintColor: UIColor.systemOrange)
            iconStackView.addArrangedSubview(warmUpView)
        }
        
        // Duration
        if let endDate = section.endDate {
            let formatter = DateComponentsFormatter()
            if DateInterval(start: section.startDate, end: endDate).duration < 60 {
                formatter.allowedUnits = [.second]
            } else {
                formatter.allowedUnits = [.minute, .hour]
            }
            formatter.unitsStyle = .short
            guard let duration = formatter.string(from: section.startDate, to: endDate) else { assertionFailure(); return }
            let durationView = IconLabelView.forAutoLayout()
            durationView.configure(iconName: "clock.fill", title: duration)
            iconStackView.addArrangedSubview(durationView)
        }
        
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
        contentView.addSubview(separatorView)
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
        NSLayoutConstraint.activate([
            separatorView.heightAnchor ⩵ 1,
            separatorView.leftAnchor ⩵ contentView.leftAnchor + 17,
            separatorView.rightAnchor ⩵ contentView.rightAnchor - 17,
            separatorView.topAnchor ⩵ iconStackView.bottomAnchor + 15
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
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.tertiaryLabel
        return view
    }
}

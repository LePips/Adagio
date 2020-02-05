//
//  PracticeEntryCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/4/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PracticeEntryCell: BasicCollectionViewCell {
    
    private lazy var cardView = makeCardView()
    private lazy var dateLabel = makeDateLabel()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var stackView = makeStackView()
    
    func configure(practice: Practice) {
        guard let endDate = practice.endDate else { assertionFailure("Practice not ended"); return }
        
        titleLabel.text = practice.title
        
        let calendar = Calendar.current
        if calendar.isDateInToday(practice.startDate) {
            dateLabel.text = "Today"
        } else {

        }
        
        for subview in stackView.subviews {
            subview.removeFromSuperview()
        }
        
        // Duration
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .short
        guard let duration = formatter.string(from: practice.startDate, to: endDate) else { assertionFailure(); return }
        let durationView = IconLabelView.forAutoLayout()
        durationView.configure(iconName: "clock.fill", title: duration)
        stackView.addArrangedSubview(durationView)
    }
    
    override func setupSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor ⩵ contentView.topAnchor + 10,
            cardView.leftAnchor ⩵ contentView.leftAnchor + 17,
            cardView.rightAnchor ⩵ contentView.rightAnchor - 17,
            cardView.bottomAnchor ⩵ contentView.bottomAnchor - 10
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor ⩵ cardView.topAnchor + 10,
            dateLabel.leftAnchor ⩵ cardView.leftAnchor + 10
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ dateLabel.bottomAnchor + 10,
            titleLabel.leftAnchor ⩵ cardView.leftAnchor + 10
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            stackView.leftAnchor ⩵ cardView.leftAnchor + 10,
            stackView.heightAnchor ⩵ 20
        ])
    }
    
    private func makeCardView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.tertiarySystemFill
        view.layer.cornerRadius = 8.91
        return view
    }
    
    private func makeDateLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Adagio.Text.primary
        return label
    }
    
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }
}

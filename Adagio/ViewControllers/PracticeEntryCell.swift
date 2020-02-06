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
    private lazy var iconStackView = makeIconStackView()
    private lazy var pieceStackView = makePieceStackView()
    
    func configure(practice: Practice) {
        guard let endDate = practice.endDate else { assertionFailure("Practice not ended"); return }
        
        titleLabel.text = practice.title
        
        let calendar = Calendar.current
        if calendar.isDateInToday(practice.startDate) {
            dateLabel.text = "Today"
        } else {
            let dateFormatter = DateFormatter(format: "E, MMM d")
            dateLabel.text = dateFormatter.string(from: practice.startDate)
        }
        
        for subview in iconStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for subview in pieceStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        // Duration
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .short
        guard let duration = formatter.string(from: practice.startDate, to: endDate) else { assertionFailure(); return }
        let durationView = IconLabelView.forAutoLayout()
        durationView.configure(iconName: "clock.fill", title: duration)
        iconStackView.addArrangedSubview(durationView)
        
        // Notes
        if let _ = practice.note {
            let notesView = IconLabelView.forAutoLayout()
            notesView.configure(iconName: "text.alignleft", title: "Notes")
            iconStackView.addArrangedSubview(notesView)
        }
        
        // Pieces
        for section in practice.sections ?? [] {
            let sectionView = SectionView.forAutoLayout()
            sectionView.configure(section: section as! Section)
            pieceStackView.addArrangedSubview(sectionView)
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconStackView)
        contentView.addSubview(pieceStackView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor ⩵ contentView.topAnchor + 5,
            cardView.leftAnchor ⩵ contentView.leftAnchor + 17,
            cardView.rightAnchor ⩵ contentView.rightAnchor - 17,
            cardView.bottomAnchor ⩵ contentView.bottomAnchor - 5
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
            iconStackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            iconStackView.leftAnchor ⩵ cardView.leftAnchor + 10,
            iconStackView.heightAnchor ⩵ 20
        ])
        NSLayoutConstraint.activate([
            pieceStackView.topAnchor ⩵ iconStackView.bottomAnchor + 10,
            pieceStackView.leftAnchor ⩵ cardView.leftAnchor + 10,
            pieceStackView.rightAnchor ⩵ cardView.rightAnchor - 10
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
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Adagio.Text.primary
        return label
    }
    
    private func makeIconStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }
    
    private func makePieceStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }
}

class PracticeEntryTableCell: AdagioCell {
    
    private lazy var cardView = makeCardView()
    private lazy var dateLabel = makeDateLabel()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var iconStackView = makeIconStackView()
    private lazy var pieceStackView = makePieceStackView()
    
    func configure(practice: Practice) {
        guard let endDate = practice.endDate else { assertionFailure("Practice not ended"); return }
        
        titleLabel.text = practice.title
        
        let calendar = Calendar.current
        if calendar.isDateInToday(practice.startDate) {
            dateLabel.text = "Today"
        } else {
            let dateFormatter = DateFormatter(format: "E, MMM d")
            dateLabel.text = dateFormatter.string(from: practice.startDate)
        }
        
        for subview in iconStackView.subviews {
            subview.removeFromSuperview()
        }
        
        // Duration
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .short
        guard let duration = formatter.string(from: practice.startDate, to: endDate) else { assertionFailure(); return }
        let durationView = IconLabelView.forAutoLayout()
        durationView.configure(iconName: "clock.fill", title: duration)
        iconStackView.addArrangedSubview(durationView)
        
        // Notes
        if let _ = practice.note {
            let notesView = IconLabelView.forAutoLayout()
            notesView.configure(iconName: "text.alignleft", title: "Notes")
            iconStackView.addArrangedSubview(notesView)
        }
        
        // Pieces
        for section in practice.sections ?? [] {
            let sectionView = SectionView.forAutoLayout()
            sectionView.configure(section: section as! Section)
            pieceStackView.addArrangedSubview(sectionView)
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(cardView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconStackView)
        contentView.addSubview(pieceStackView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor ⩵ contentView.topAnchor + 5,
            cardView.leftAnchor ⩵ contentView.leftAnchor + 17,
            cardView.rightAnchor ⩵ contentView.rightAnchor - 17,
            cardView.bottomAnchor ⩵ contentView.bottomAnchor - 5
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
            iconStackView.topAnchor ⩵ titleLabel.bottomAnchor + 10,
            iconStackView.leftAnchor ⩵ cardView.leftAnchor + 10,
            iconStackView.heightAnchor ⩵ 20
        ])
        NSLayoutConstraint.activate([
            pieceStackView.topAnchor ⩵ iconStackView.bottomAnchor + 10,
            pieceStackView.leftAnchor ⩵ cardView.leftAnchor + 10,
            pieceStackView.rightAnchor ⩵ cardView.rightAnchor - 10
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
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Adagio.Text.primary
        return label
    }
    
    private func makeIconStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }
    
    private func makePieceStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }
}

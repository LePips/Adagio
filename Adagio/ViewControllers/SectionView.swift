//
//  SectionView.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/5/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class SectionView: BasicView {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var durationLabel = makeDurationLabel()
    
    func configure(section: Section) {
        titleLabel.text = section.title
        
        if let endDate = section.endDate {
            let formatter = DateComponentsFormatter()
            if DateInterval(start: section.startDate, end: endDate).duration < 60 {
                formatter.allowedUnits = [.second]
            } else {
                formatter.allowedUnits = [.minute, .hour]
            }
            formatter.unitsStyle = .short
            guard let duration = formatter.string(from: section.startDate, to: endDate) else { assertionFailure(); return }
            durationLabel.text = duration
        }
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(durationLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor ⩵ centerYAnchor,
            titleLabel.leftAnchor ⩵ leftAnchor
        ])
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor ⩵ centerYAnchor,
            durationLabel.rightAnchor ⩵ rightAnchor,
            titleLabel.rightAnchor ⩵ durationLabel.leftAnchor
        ])
        NSLayoutConstraint.activate([
            heightAnchor ⩵ "height".height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 14, weight: .medium))
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeDurationLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        return label
    }
}

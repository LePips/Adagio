//
//  CurrentSessionBar.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/29/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class CurrentSessionBar: BasicView {
    
    private lazy var topSeparatorView = makeSeparatorView()
    private lazy var bottomSeparatorView = makeSeparatorView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var durationLabel = makeDurationLabel()
    private lazy var smallDurationLabel = makeSmallDurationLabel()
    private lazy var smallTitleLabel = makeSmallTitleLabel()
    private lazy var sectionTitleLabel = makeSectionTitleLabel()
    
    private var practice: Practice?
    
    func configure(practice: Practice?) {
        titleLabel.text = practice?.title
        smallTitleLabel.text = ""
        sectionTitleLabel.text = ""
        smallDurationLabel.isHidden = true
        self.practice = practice
    }
    
    func configure(practice: Practice?, section: Section?) {
        titleLabel.text = ""
        smallTitleLabel.text = practice?.title
        sectionTitleLabel.text = section?.title
        smallDurationLabel.isHidden = false
        self.practice = practice
    }
    
    func set(duration: TimeInterval) {
        if let section = CurrentPracticeState.core.state.section {
            setSectionedDurations(duration: duration, section: section)
        } else {
            setUnsectionedDurations(duration: duration)
        }
    }
    
    private func setUnsectionedDurations(duration: TimeInterval) {
        smallDurationLabel.text = nil
        durationLabel.text = intervalFormat(duration)
    }
    
    private func setSectionedDurations(duration: TimeInterval, section: Section) {
        smallDurationLabel.text = intervalFormat(duration)
        guard let practice = practice else { return }
        let diff = DateInterval(start: practice.startDate, end: section.startDate)
        durationLabel.text = intervalFormat(duration - diff.duration)
    }
    
    private func intervalFormat(_ interval: TimeInterval) -> String? {
        var timeString: String?

        if interval < 60 {
            if Int(interval) > 9 {
                timeString = "0:\(Int(interval))"
            } else {
                timeString = "0:0\(Int(interval))"
            }
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .dropLeading
            formatter.allowedUnits = [.second, .minute, .hour]
            timeString = formatter.string(from: interval)
        }
        return timeString
    }
    
    override func setupSubviews() {
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        addSubview(titleLabel)
        addSubview(durationLabel)
        addSubview(smallDurationLabel)
        addSubview(smallTitleLabel)
        addSubview(sectionTitleLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor ⩵ topAnchor,
            topSeparatorView.heightAnchor ⩵ 1,
            topSeparatorView.leftAnchor ⩵ leftAnchor + 17,
            topSeparatorView.rightAnchor ⩵ rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            bottomSeparatorView.bottomAnchor ⩵ bottomAnchor,
            bottomSeparatorView.heightAnchor ⩵ 1,
            bottomSeparatorView.leftAnchor ⩵ leftAnchor + 17,
            bottomSeparatorView.rightAnchor ⩵ rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor ⩵ centerYAnchor,
            titleLabel.leftAnchor ⩵ leftAnchor + 17,
            titleLabel.rightAnchor ⩵ durationLabel.leftAnchor - 20
        ])
        NSLayoutConstraint.activate([
            durationLabel.bottomAnchor ⩵ bottomAnchor - 15,
            durationLabel.rightAnchor ⩵ rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            smallDurationLabel.centerYAnchor ⩵ smallTitleLabel.centerYAnchor,
            smallDurationLabel.rightAnchor ⩵ rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            sectionTitleLabel.bottomAnchor ⩵ bottomAnchor - 15,
            sectionTitleLabel.leftAnchor ⩵ leftAnchor + 17,
            sectionTitleLabel.rightAnchor ⩵ durationLabel.leftAnchor - 20
        ])
        NSLayoutConstraint.activate([
            smallTitleLabel.bottomAnchor ⩵ sectionTitleLabel.topAnchor - 5,
            smallTitleLabel.leftAnchor ⩵ leftAnchor + 17,
            smallTitleLabel.rightAnchor ⩵ durationLabel.leftAnchor - 20
        ])
    }
    
    override func viewDidLoad() {
        backgroundColor = UIColor.Adagio.backgroundColor
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeDurationLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        label.textAlignment = .right
        return label
    }
    
    private func makeSmallDurationLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeSmallTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeSectionTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
}

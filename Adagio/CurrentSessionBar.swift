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
    
    func configure(practice: Practice?) {
        titleLabel.text = practice?.title
    }
    
    func set(duration: TimeInterval) {
        var timeString: String?

        if duration < 60 {
            if duration > 9 {
                timeString = "0:\(Int(duration))"
            } else {
                timeString = "0:0\(Int(duration))"
            }
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .dropLeading
            formatter.allowedUnits = [.second, .minute, .hour]
            timeString = formatter.string(from: duration)
        }
        
        durationLabel.text = timeString
    }
    
    override func setupSubviews() {
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        addSubview(titleLabel)
        addSubview(durationLabel)
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
            titleLabel.rightAnchor ⩵ durationLabel.leftAnchor
        ])
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor ⩵ centerYAnchor,
            durationLabel.rightAnchor ⩵ rightAnchor - 17
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
}

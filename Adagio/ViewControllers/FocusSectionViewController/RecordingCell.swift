//
//  RecordingCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

struct RecordingCellConfiguration {
    
    var createAction: () -> Void
    var recordings: [Recording]
    var selectAction: (Recording) -> Void
}

class RecordingButton: BasicView {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var durationLabel = makeDurationLabel()
    
    private var selectedAction: ((Recording) -> Void)?
    private var recording: Recording?
    
    func configure(recording: Recording, selectedAction: @escaping (Recording) -> Void) {
        self.recording = recording
        self.selectedAction = selectedAction
        
        titleLabel.text = recording.title
        durationLabel.text = stringFromTimeInterval(interval: recording.duration)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selected))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func selected() {
        selectedAction?(recording!)
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(durationLabel)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ topAnchor,
            titleLabel.leftAnchor ⩵ leftAnchor
        ])
        NSLayoutConstraint.activate([
            durationLabel.centerYAnchor ⩵ titleLabel.centerYAnchor,
            durationLabel.rightAnchor ⩵ rightAnchor - 34
        ])
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.systemBlue
        return label
    }
    
    private func makeDurationLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let min = Int(interval / 60)
        let sec = Int(interval.truncatingRemainder(dividingBy: 60))
        let milli = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d:%02d", min, sec, milli)
    }
}

class RecordingCell: AdagioCell {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var addButton = makeAddButton()
    private lazy var stackView = makeStackView()
    private lazy var separatorView = makeSeparatorView()
    private lazy var noneLabel = makeNoneLabel()
    private var configuration: RecordingCellConfiguration?
    
    func configure(with configuration: RecordingCellConfiguration) {
        self.configuration = configuration
        
        for subview in stackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for recording in configuration.recordings.filter({ $0.title != "" }) {
            let recordingButton = RecordingButton.forAutoLayout()
            recordingButton.configure(recording: recording, selectedAction: configuration.selectAction)
            
            stackView.addArrangedSubview(recordingButton)
            
            NSLayoutConstraint.activate([
                recordingButton.heightAnchor ⩵ 30,
                recordingButton.widthAnchor ⩵ contentView.widthAnchor
            ])
        }
        
        self.noneLabel.isHidden = !stackView.arrangedSubviews.isEmpty
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
        label.text = "Recordings"
        return label
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(addSelected), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Add Recording", for: .normal)
        return button
    }
    
    @objc private func addSelected() {
        Haptics.main.light()
        configuration?.createAction()
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

//
//  SegmentCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/5/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

protocol SegmentCellDelegate {
    
    func detailSelected()
    func historySelected()
}

class SegmentConfiguration {
    
    var editing: Bool
    var delegate: SegmentCellDelegate
    
    init(editing: Bool, delegate: SegmentCellDelegate) {
        self.editing = editing
        self.delegate = delegate
    }
}

class SegmentCell: AdagioCell, Editable {
    
    private lazy var segmentedControl = makeSegmentedControl()
    private var configuration: SegmentConfiguration?
    
    func configure(configuration: SegmentConfiguration) {
        self.configuration = configuration
        
        self.isEditing = configuration.editing
    }
    
    override var isEditing: Bool {
        didSet {
            if isEditing {
                if segmentedControl.selectedSegmentIndex != 0 {
                    configuration?.delegate.detailSelected()
                }
                segmentedControl.selectedSegmentIndex = 0
                segmentedControl.isEnabled = false
            } else {
                segmentedControl.isEnabled = true
            }
        }
    }
    
    override func setupSubviews() {
        contentView.addSubview(segmentedControl)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor ⩵ contentView.centerXAnchor,
            segmentedControl.centerYAnchor ⩵ contentView.centerYAnchor,
            segmentedControl.leftAnchor ⩵ contentView.leftAnchor + 17,
            segmentedControl.rightAnchor ⩵ contentView.rightAnchor - 17
        ])
    }
    
    private func makeSegmentedControl() -> UISegmentedControl {
        let control = UISegmentedControl.forAutoLayout()
        control.insertSegment(withTitle: "Details", at: 0, animated: false)
        control.insertSegment(withTitle: "History", at: 1, animated: false)
        control.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }
    
    @objc private func segmentValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            configuration?.delegate.detailSelected()
        case 1:
            configuration?.delegate.historySelected()
        default: ()
        }
    }
}

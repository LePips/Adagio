//
//  DeletePracticeCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/1/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

struct DeletePracticeConfiguration {
    
    var selectedAction: () -> Void
}

class DeletePracticeCell: BasicTableViewCell {
    
    private lazy var addPieceButton = makeAddPieceButton()
    
    private var configuration: DeletePracticeConfiguration?
    
    func configure(configuration: DeletePracticeConfiguration) {
        self.configuration = configuration
    }
    
    override func setupSubviews() {
        contentView.addSubview(addPieceButton)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            addPieceButton.centerXAnchor ⩵ contentView.centerXAnchor,
            addPieceButton.centerYAnchor ⩵ contentView.centerYAnchor,
            addPieceButton.heightAnchor ⩵ 40,
            addPieceButton.widthAnchor ⩵ contentView.widthAnchor × 0.76
        ])
    }
    
    private func makeAddPieceButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.addTarget(self, action: #selector(addPieceSelected), for: .touchUpInside)
        button.setTitle("Delete Practice", for: .normal)
//        button.setBackgroundColor(UIColor.systemPink.withAlphaComponent(0.15), for: .normal)
        button.layer.cornerRadius = 8.91
        button.setTitleColor(UIColor.systemPink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }
    
    @objc private func addPieceSelected() {
        Haptics.main.light()
        configuration?.selectedAction()
    }
}

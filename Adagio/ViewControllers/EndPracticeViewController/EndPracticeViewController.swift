//
//  EndPracticeViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/28/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class EndPracticeViewController: BasicViewController {
    
    private lazy var cardView = makeCardView()
    private lazy var confettiLabel = makeConfettiLabel()
    private lazy var practiceTitleLabel = makePracticeTitleLabel()
    private lazy var durationLabel = makeDurationLabel()
    private lazy var attributeStackView = makeAttributeStackView()
    private lazy var sectionStackView = makeSectionStackView()
    private lazy var doneButton = makeDoneButton()
    private lazy var doneButtonCenterYAnchor = makeDoneButtonCenterYAnchor()
    
    private let viewModel: EndPracticeViewModel
    
    init(viewModel: EndPracticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(confettiLabel)
        view.addSubview(practiceTitleLabel)
        view.addSubview(durationLabel)
        view.addSubview(attributeStackView)
        view.addSubview(sectionStackView)
        view.addSubview(doneButton)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor ⩵ 50,
            doneButton.centerXAnchor ⩵ view.centerXAnchor,
            doneButton.widthAnchor ⩵ view.widthAnchor × 0.8,
            doneButtonCenterYAnchor
        ])
        NSLayoutConstraint.activate([
            sectionStackView.bottomAnchor ⩵ doneButton.topAnchor - 40,
            sectionStackView.leftAnchor ⩵ doneButton.leftAnchor + 17,
            sectionStackView.rightAnchor ⩵ doneButton.rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            attributeStackView.bottomAnchor ⩵ sectionStackView.topAnchor,
            attributeStackView.leftAnchor ⩵ doneButton.leftAnchor + 17,
            attributeStackView.rightAnchor ⩵ doneButton.rightAnchor - 17
        ])
        NSLayoutConstraint.activate([
            durationLabel.leftAnchor ⩵ attributeStackView.leftAnchor,
            durationLabel.bottomAnchor ⩵ attributeStackView.topAnchor - 20
        ])
        NSLayoutConstraint.activate([
            practiceTitleLabel.leftAnchor ⩵ durationLabel.leftAnchor,
            practiceTitleLabel.rightAnchor ⩵ doneButton.rightAnchor,
            practiceTitleLabel.bottomAnchor ⩵ durationLabel.topAnchor - 5
        ])
        NSLayoutConstraint.activate([
            confettiLabel.centerXAnchor ⩵ view.centerXAnchor,
            confettiLabel.bottomAnchor ⩵ practiceTitleLabel.topAnchor - 10
        ])
        NSLayoutConstraint.activate([
            cardView.bottomAnchor ⩵ doneButton.topAnchor - 10,
            cardView.leftAnchor ⩵ doneButton.leftAnchor,
            cardView.rightAnchor ⩵ doneButton.rightAnchor,
            cardView.topAnchor ⩵ confettiLabel.topAnchor - 20
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        practiceTitleLabel.text = viewModel.practice.title
        
        // Duration
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .short
        guard let duration = formatter.string(from: viewModel.practice.startDate, to: viewModel.practice.endDate!) else { assertionFailure(); return }
        durationLabel.text = duration
        
        view.backgroundColor = UIColor.Adagio.backgroundColor
        
        // Notes
        if viewModel.practice.note != nil {
            let notesView = IconLabelView.forAutoLayout()
            notesView.configure(iconName: "text.alignleft", title: "Notes", imageTintColor: UIColor.secondaryLabel, titleTintColor: UIColor.secondaryLabel)
            attributeStackView.addArrangedSubview(notesView)
        }
        
        // Sections
        var sections = viewModel.practice.sections?.compactMap({ $0 as? Section }) ?? []
//        sections.sort(by: { $0.warmUp && !$1.warmUp })
        if sections.count > 8 {
            sections = Array(sections.prefix(upTo: 8))
        }
        
        doneButtonCenterYAnchor.constant += CGFloat(sections.count) * 10
        view.layoutIfNeeded()
        
        if sections.isEmpty {
            let emptyLabel = UILabel.forAutoLayout()
            emptyLabel.text = "No Sections"
            emptyLabel.textColor = UIColor.secondaryLabel
            emptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            sectionStackView.addArrangedSubview(emptyLabel)
        }
        
        for section in sections {
            let sectionView = SectionView.forAutoLayout()
            sectionView.configure(section: section)
            sectionStackView.addArrangedSubview(sectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let transform = CGAffineTransform(rotationAngle: -0.6)
        transform.scaledBy(x: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.confettiLabel.transform = transform
        }) { (_) in
            UIView.animate(withDuration: 0.15) {
                self.confettiLabel.transform = CGAffineTransform(rotationAngle: 0.2)
            }
        }
    }
    
    private func makeCardView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 14
        return view
    }
    
    private func makeConfettiLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        label.text = "🎉"
        return label
    }
    
    private func makePracticeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeDurationLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.secondaryLabel
        return label
    }
    
    private func makeAttributeStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .horizontal
        return stackView
    }
    
    private func makeSectionStackView() -> UIStackView {
        let stackView = UIStackView.forAutoLayout()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }
    
    private func makeDoneButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(doneSelected), for: .touchUpInside)
        button.layer.cornerRadius = 14
        button.backgroundColor = UIColor.secondarySystemBackground
        button.setTitle("Done", for: .normal)
        return button
    }
    
    @objc private func doneSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    private func makeDoneButtonCenterYAnchor() -> NSLayoutConstraint {
        return doneButton.topAnchor ⩵ view.centerYAnchor + 90
    }
}

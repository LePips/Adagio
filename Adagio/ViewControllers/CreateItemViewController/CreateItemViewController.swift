//
//  CreateItemViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import UIKit
import SharedPips

class CreateItemViewController<ObjectType: NSManagedObject & Titlable>: BasicViewController, UITextViewDelegate {
    
    private lazy var cardView = makeCardView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var textField = makeTextField()
    private lazy var separatorView = makeSeparatorView()
    private lazy var doneButton = makeDoneButton()
    private lazy var cancelButton = makeCancelButton()
    
    private let viewModel: CreateItemViewModel<ObjectType>
    
    init(viewModel: CreateItemViewModel<ObjectType>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(separatorView)
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            textField.bottomAnchor ⩵ view.centerYAnchor,
            textField.centerXAnchor ⩵ view.centerXAnchor,
            textField.leftAnchor ⩵ cardView.leftAnchor + 20,
            textField.rightAnchor ⩵ cardView.rightAnchor - 20
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor ⩵ view.centerXAnchor,
            titleLabel.bottomAnchor ⩵ textField.topAnchor - 10
        ])
        NSLayoutConstraint.activate([
            separatorView.topAnchor ⩵ textField.bottomAnchor + 10,
            separatorView.leftAnchor ⩵ textField.leftAnchor,
            separatorView.rightAnchor ⩵ textField.rightAnchor,
            separatorView.heightAnchor ⩵ 1
        ])
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor ⩵ view.centerXAnchor,
            doneButton.topAnchor ⩵ separatorView.bottomAnchor + 20
        ])
        NSLayoutConstraint.activate([
            cardView.leftAnchor ⩵ view.leftAnchor + 10,
            cardView.rightAnchor ⩵ view.rightAnchor - 10,
            cardView.topAnchor ⩵ titleLabel.topAnchor - 20,
            cardView.bottomAnchor ⩵ doneButton.bottomAnchor + 20
        ])
        NSLayoutConstraint.activate([
            cancelButton.topAnchor ⩵ cardView.bottomAnchor + 20,
            cancelButton.leftAnchor ⩵ view.leftAnchor + 10,
            cancelButton.rightAnchor ⩵ view.rightAnchor - 10,
            cancelButton.heightAnchor ⩵ 56
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewModel.title
        doneButton.setTitle(viewModel.doneButtonTitle, for: .normal)
        
        doneButton.isEnabled = false
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func makeCardView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondarySystemBackground
        view.layer.cornerRadius = 8.91
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makeTextField() -> UITextView {
        let textView = UITextView.forAutoLayout()
        textView.removePadding()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = UIColor.Adagio.textColor
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }
    
    private func makeSeparatorView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeDoneButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.secondaryLabel, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(doneSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func doneSelected() {
        viewModel.saveItem()
    }
    
    private func makeCancelButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
        button.backgroundColor = UIColor.secondarySystemBackground
        button.layer.cornerRadius = 14
        button.setTitle("Cancel", for: .normal)
        return button
    }
    
    @objc private func cancelSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        doneButton.isEnabled = !textView.text.isEmpty
        viewModel.set(text: textView.text)
    }
}

extension CreateItemViewController: CreateItemViewModelDelegate {
    
    func itemSaved() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

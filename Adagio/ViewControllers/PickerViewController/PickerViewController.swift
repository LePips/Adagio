//
//  PickerViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import UIKit
import SharedPips

class PickerViewController<ObjectType: NSManagedObject & Titlable>: BasicViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let animator = FadeInAnimator()
    private lazy var cardView = makeCardView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var pickerView = makePickerView()
    private lazy var doneButton = makeDoneButton()
    private lazy var cancelButton = makeCancelButton()
    
    private let viewModel: CoreDataPickerViewModel<ObjectType>
    
    init(viewModel: CoreDataPickerViewModel<ObjectType>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(titleLabel)
        view.addSubview(pickerView)
        view.addSubview(doneButton)
        view.addSubview(cancelButton)
    }
    
    // Views done bottom-up in non-standard fashion to make height more dynamic
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor - 15,
            cancelButton.leftAnchor ⩵ view.leftAnchor + 10,
            cancelButton.rightAnchor ⩵ view.rightAnchor - 10,
            cancelButton.heightAnchor ⩵ 56
        ])
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor ⩵ cancelButton.topAnchor - 35,
            doneButton.centerXAnchor ⩵ view.centerXAnchor
        ])
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor ⩵ doneButton.topAnchor - 15,
            pickerView.leftAnchor ⩵ view.leftAnchor + 10,
            pickerView.rightAnchor ⩵ view.rightAnchor - 10
        ])
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor ⩵ pickerView.topAnchor - 10,
            titleLabel.centerXAnchor ⩵ view.centerXAnchor
        ])
        NSLayoutConstraint.activate([
            cardView.bottomAnchor ⩵ cancelButton.topAnchor - 20,
            cardView.leftAnchor ⩵ view.leftAnchor + 10,
            cardView.rightAnchor ⩵ view.rightAnchor - 10,
            cardView.topAnchor ⩵ titleLabel.topAnchor - 20
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewModel.title
        doneButton.setTitle(viewModel.doneButtonTitle, for: .normal)
        pickerView.reloadAllComponents()
    }
    
    private func makeCardView() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.tertiarySystemBackground
        view.layer.cornerRadius = 8.91
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.Adagio.textColor
        return label
    }
    
    private func makePickerView() -> UIPickerView {
        let picker = UIPickerView.forAutoLayout()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .clear
        return picker
    }
    
    private func makeDoneButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(doneSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func doneSelected() {
        viewModel.selectedAction(viewModel.objects[pickerView.selectedRow(inComponent: 0)])
        dismiss(animated: true, completion: nil)
    }
    
    private func makeCancelButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 14
        button.setTitle("Cancel", for: .normal)
        return button
    }
    
    @objc private func cancelSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.objects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.objects[row].title
    }
}

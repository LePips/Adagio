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

class PickerViewController: BasicViewController {
    
    private lazy var cardView = makeCardView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var createButton = makeCreateButton()
    private lazy var pickerView = makePickerView()
    private lazy var doneButton = makeDoneButton()
    private lazy var cancelButton = makeCancelButton()
    
    private let viewModel: CoreDataPickerViewModelProtocol
    
    init(viewModel: CoreDataPickerViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(titleLabel)
        view.addSubview(createButton)
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
            createButton.centerYAnchor ⩵ titleLabel.centerYAnchor,
            createButton.rightAnchor ⩵ cardView.rightAnchor - 20
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
        
        doneButton.isEnabled = !viewModel.objects.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.alpha = 1
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
    
    private func makeCreateButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        button.setImage(UIImage(systemName: "plus", withConfiguration: configuration), for: .normal)
        button.addTarget(self, action: #selector(createSelected), for: .touchUpInside)
        return button
    }
    
    // MARK: - createSelected
    @objc private func createSelected() {
        let createItemViewController = viewModel.getCreateItemViewController(doneAction: doneAction)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0
        }
        self.present(createItemViewController, animated: true, completion: nil)
    }
    
    private func doneAction() {
        self.viewModel.reloadRows()
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
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
        button.setTitleColor(UIColor.secondaryLabel, for: .disabled)
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
        button.backgroundColor = UIColor.secondarySystemBackground
        button.layer.cornerRadius = 14
        button.setTitle("Cancel", for: .normal)
        return button
    }
    
    @objc private func cancelSelected() {
        dismiss(animated: true, completion: nil)
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.objects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.objects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        doneButton.isEnabled = true
    }
}

extension PickerViewController: PickerViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
            self.doneButton.isEnabled = !self.viewModel.objects.isEmpty
        }
    }
    
    func selectItem(withTitle: String) {
        DispatchQueue.main.async {
            self.viewModel.reloadRows()
            guard let index = self.viewModel.objects.firstIndex(of: withTitle) else { return }
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func presentCreateInstrumentViewController(with viewModel: CreateItemViewModel<Instrument>) {
        let createInstrumentViewController = CreateItemViewController<Instrument>(viewModel: viewModel)
        self.present(createInstrumentViewController, animated: true, completion: nil)
    }
    
    func presentCreateGroupViewController(with viewModel: CreateItemViewModel<Group>) {
        let createGroupViewController = CreateItemViewController<Group>(viewModel: viewModel)
        self.present(createGroupViewController, animated: true, completion: nil)
    }
}

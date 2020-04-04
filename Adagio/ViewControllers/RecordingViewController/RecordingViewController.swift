//
//  RecordingViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class RecordingViewController: BasicViewController, UIAdaptivePresentationControllerDelegate {
    
    private lazy var cardView = makeCardView()
    private lazy var titleTextField = makeTitleTextField()
    private lazy var textFieldTarget = makeTextFieldTarget()
    private lazy var timerLabel = makeTimerLabel()
    private lazy var recordButton = makeRecordButton()
    private lazy var doneButton = makeDoneButton()
    private lazy var cancelButton = makeCancelButton()
    private lazy var textFieldBottomAnchor = makeTextFieldBottomAnchor()
    
    private let viewModel: RecordingViewModel
    
    init(viewModel: RecordingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    override func setupSubviews() {
        view.addSubview(cardView)
        view.addSubview(titleTextField)
        view.addSubview(textFieldTarget)
        view.addSubview(timerLabel)
        view.addSubview(recordButton)
        view.addSubview(cancelButton)
        doneButton.isEnabled = false
        
        titleTextField.text = viewModel.recording.title
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor - 15,
            cancelButton.leftAnchor ⩵ view.leftAnchor + 10,
            cancelButton.rightAnchor ⩵ view.rightAnchor - 10,
            cancelButton.heightAnchor ⩵ 56
        ])
        NSLayoutConstraint.activate([
            recordButton.bottomAnchor ⩵ cancelButton.topAnchor - 45,
            recordButton.centerXAnchor ⩵ view.centerXAnchor,
            recordButton.heightAnchor ⩵ 90,
            recordButton.widthAnchor ⩵ 90
        ])
        NSLayoutConstraint.activate([
            textFieldBottomAnchor,
            timerLabel.leftAnchor ⩵ view.centerXAnchor - "00:0".width(withConstrainedHeight: 50, font: UIFont.systemFont(ofSize: 18, weight: .medium)),
        ])
        NSLayoutConstraint.activate([
            titleTextField.bottomAnchor ⩵ timerLabel.topAnchor - 15,
            titleTextField.leftAnchor ⩵ cardView.leftAnchor + 20,
            titleTextField.rightAnchor ⩵ cardView.rightAnchor - 20
        ])
        NSLayoutConstraint.activate([
            textFieldTarget.leftAnchor ⩵ cardView.leftAnchor,
            textFieldTarget.rightAnchor ⩵ cardView.rightAnchor,
            textFieldTarget.bottomAnchor ⩵ timerLabel.topAnchor,
            textFieldTarget.topAnchor ⩵ cardView.topAnchor
        ])
        NSLayoutConstraint.activate([
            cardView.bottomAnchor ⩵ cancelButton.topAnchor - 20,
            cardView.leftAnchor ⩵ view.leftAnchor + 10,
            cardView.rightAnchor ⩵ view.rightAnchor - 10,
            cardView.topAnchor ⩵ titleTextField.topAnchor - 20
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presentationController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.checkPermission()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textFieldBottomAnchor.constant = -100
            UIView.animate(withDuration: 0.2) {
                if !self.viewModel.isRecording {
                    self.timerLabel.alpha = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textFieldBottomAnchor.constant = -30
            UIView.animate(withDuration: 0.2) {
                self.timerLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func makeCardView() -> UIView {
        let view = UIView.forAutoLayout()
        view.layer.cornerRadius = 8.91
        view.backgroundColor = UIColor.Adagio.backgroundColor
        return view
    }
    
    private func makeTitleTextField() -> UITextField {
        let textField = UITextField.forAutoLayout()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = UIColor.Adagio.textColor
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(hideKeyboardSelected), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(didBecomeFirstResponder), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return textField
    }
    
    @objc private func hideKeyboardSelected() {
        view.endEditing(true)
    }
    
    @objc private func didBecomeFirstResponder() {
        titleTextField.selectAll(nil)
    }
    
    @objc private func editingChanged() {
        viewModel.set(title: titleTextField.text ?? "New Recording")
    }
    
    private func makeTextFieldTarget() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.addTarget(self, action: #selector(targetSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func targetSelected() {
        titleTextField.becomeFirstResponder()
    }
    
    private func makeTimerLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.text = "00:00:00"
        return label
    }
    
    private func makeRecordButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.layer.cornerRadius = 45
        button.tintColor = UIColor.systemRed
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.systemRed
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        
        button.addTarget(self, action: #selector(recordSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func recordSelected() {
        Haptics.main.light()
        viewModel.recordSelected()
    }
    
    private func makeDoneButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.secondaryLabel, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(doneSelected), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        return button
    }
    
    @objc private func doneSelected() {
        viewModel.doneSelected()
        dismiss(animated: true, completion: nil)
    }
    
    private func makeCancelButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
        button.backgroundColor = UIColor.Adagio.backgroundColor
        button.layer.cornerRadius = 14
        button.setTitle("Cancel", for: .normal)
        return button
    }
    
    @objc private func cancelSelected() {
        viewModel.cancelSelected()
        dismiss(animated: true, completion: nil)
    }
    
    private func makeTextFieldBottomAnchor() -> NSLayoutConstraint {
        return timerLabel.bottomAnchor ⩵ recordButton.topAnchor - 30
    }
}

// MARK: - RecrodingViewModelDelegate
extension RecordingViewController: RecordingViewModelDelegate {
    
    func setRecord() {
//        doneButton.isEnabled = true
//
//        UIView.animate(withDuration: 0.2) {
//            self.recordButton.backgroundColor = UIColor.systemPink
//        }
        
        doneSelected()
    }
    
    func setStop() {
        doneButton.isEnabled = false
        
        UIView.animate(withDuration: 0.1) {
            self.recordButton.backgroundColor = UIColor.clear
            self.recordButton.layer.borderWidth = 2
            self.recordButton.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    func updateTimer(with interval: TimeInterval) {
        let min = Int(interval / 60)
        let sec = Int(interval.truncatingRemainder(dividingBy: 60))
        let milli = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let totalTimeString = String(format: "%02d:%02d:%02d", min, sec, milli)
        timerLabel.text = totalTimeString
    }
    
    func present(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: .none))
        present(alertVC, animated: true, completion: nil)
    }
    
    func permissionDenied() {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Permission Denied", message: "Please give Adagio microphone access", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

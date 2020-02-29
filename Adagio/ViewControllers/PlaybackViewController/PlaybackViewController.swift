//
//  PlaybackViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/23/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class PlaybackRootViewController: UINavigationController, UIAdaptivePresentationControllerDelegate {
    
    private let viewModel: PlaybackViewModel
    
    init(viewModel: PlaybackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        makeBarTransparent()
        
        self.presentationController?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [PlaybackViewController(viewModel: viewModel)]
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        viewModel.reloadAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.reloadAction()
    }
}

class PlaybackViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    private lazy var noteLabel = makeNoteLabel()
    private lazy var noteTextView = makeNoteTextView()
    private lazy var noteTextViewBottom = makeNoteTextViewBottom()
    private lazy var slider = makeSlider()
    private lazy var playButton = makePlayButton()
    private lazy var currentTimeLabel = makeCurrentTimeLabel()
    private lazy var totalTimeLabel = makeTotalTimeLabel()
    private lazy var updater = makeUpdater()
    private lazy var hideKeyboardButton = makeHideKeyboardButton()
    private lazy var keyboardTopAnchor = makeKeyboardTopAnchor()
    
    private let viewModel: PlaybackViewModel
    
    override func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(noteLabel)
        view.addSubview(noteTextView)
        view.addSubview(noteTextViewBottom)
        view.addSubview(slider)
        view.addSubview(playButton)
        view.addSubview(currentTimeLabel)
        view.addSubview(totalTimeLabel)
        view.addSubview(hideKeyboardButton)
        hideKeyboardButton.alpha = 0
        noteTextView.text = viewModel.recording.note ?? ""
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor ⩵ view.safeAreaLayoutGuide.topAnchor,
            tableView.leftAnchor ⩵ view.leftAnchor,
            tableView.rightAnchor ⩵ view.rightAnchor,
            tableView.heightAnchor ⩵ 100
        ])
        NSLayoutConstraint.activate([
            noteLabel.topAnchor ⩵ tableView.bottomAnchor + 20,
            noteLabel.leftAnchor ⩵ view.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            noteTextView.topAnchor ⩵ noteLabel.bottomAnchor + 10,
            noteTextView.leftAnchor ⩵ view.leftAnchor + 17,
            noteTextView.rightAnchor ⩵ view.rightAnchor - 17,
            keyboardTopAnchor
        ])
        NSLayoutConstraint.activate([
            noteTextViewBottom.heightAnchor ⩵ 1,
            noteTextViewBottom.leftAnchor ⩵ view.leftAnchor + 17,
            noteTextViewBottom.rightAnchor ⩵ view.rightAnchor - 17,
            noteTextViewBottom.bottomAnchor ⩵ noteTextView.bottomAnchor
        ])
        NSLayoutConstraint.activate([
            slider.centerXAnchor ⩵ view.centerXAnchor,
            slider.widthAnchor ⩵ view.widthAnchor × 0.8,
            slider.bottomAnchor ⩵ playButton.topAnchor - 30
        ])
        NSLayoutConstraint.activate([
            playButton.centerXAnchor ⩵ view.centerXAnchor,
            playButton.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor - 15,
            playButton.heightAnchor ⩵ 80
        ])
        NSLayoutConstraint.activate([
            currentTimeLabel.topAnchor ⩵ slider.bottomAnchor + 5,
            currentTimeLabel.leftAnchor ⩵ slider.leftAnchor
        ])
        NSLayoutConstraint.activate([
            totalTimeLabel.topAnchor ⩵ slider.bottomAnchor + 5,
            totalTimeLabel.rightAnchor ⩵ slider.rightAnchor
        ])
        NSLayoutConstraint.activate([
            hideKeyboardButton.heightAnchor ⩵ 40,
            hideKeyboardButton.widthAnchor ⩵ 40,
            hideKeyboardButton.rightAnchor ⩵ view.rightAnchor - 17,
            hideKeyboardButton.bottomAnchor ⩵ noteTextView.bottomAnchor - 2
        ])
    }
    
    init(viewModel: PlaybackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        _ = updater
        
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeSelected))
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = deleteBarButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func closeSelected() {
        viewModel.audioPlayer.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteSelected() {
        viewModel.deleteSelected()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let sliderDiff = view.frame.height - slider.frame.minY
            let keyboardDiff = keyboardSize.height - sliderDiff
            keyboardTopAnchor.constant = -keyboardSize.height + keyboardDiff
            UIView.animate(withDuration: 0.2) {
                self.hideKeyboardButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardTopAnchor.constant = -80
            UIView.animate(withDuration: 0.2) {
                self.hideKeyboardButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView.forAutoLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        PlaybackRow.register(tableView: tableView)
        return tableView
    }
    
    private func makeNoteLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        label.text = "Notes"
        return label
    }
    
    private func makeNoteTextView() -> UITextView {
        let textView = UITextView.forAutoLayout()
        textView.removePadding()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = UIColor.Adagio.textColor
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        return textView
    }
    
    private func makeNoteTextViewBottom() -> UIView {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.secondaryLabel
        return view
    }
    
    private func makeSlider() -> UISlider {
        let slider = UISlider.forAutoLayout()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.maximumTrackTintColor = UIColor.systemFill
        slider.minimumTrackTintColor = UIColor.white
        slider.tintColor = UIColor.white
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let thumb = UIImage(systemName: "circle.fill", withConfiguration: config)
        slider.setThumbImage(thumb, for: .normal)
        
        let lconfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let lthumb = UIImage(systemName: "circle.fill", withConfiguration: lconfig)
        slider.setThumbImage(lthumb, for: .highlighted)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(editingChanged), for: .touchUpInside)
        return slider
    }
    
    @objc private func sliderChanged() {
        updater.isPaused = true
        currentTimeLabel.text = stringFromTimeInterval(interval: TimeInterval(slider.value / 100) * viewModel.audioPlayer.duration)
    }
    
    @objc private func editingChanged() {
        viewModel.setPlaybackInterval(percentage: TimeInterval(slider.value / 100))
        updater.isPaused = false
    }
    
    private func makePlayButton() -> UIButton {
        let button = UIButton.forAutoLayout()
        button.tintColor = UIColor.Adagio.textColor
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .semibold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(playSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func playSelected() {
        viewModel.playSelected()
    }
    
    private func makeCurrentTimeLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.textColor = UIColor.Adagio.textColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }
    
    private func makeTotalTimeLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.textColor = UIColor.Adagio.textColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = stringFromTimeInterval(interval: viewModel.audioPlayer.duration)
        return label
    }
    
    private func makeUpdater() -> CADisplayLink {
        let updater = CADisplayLink(target: self, selector: #selector(trackAudio))
        updater.preferredFramesPerSecond = 60
        updater.add(to: .current, forMode: .common)
        return updater
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {

        let time = NSInteger(interval)

        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        if minutes == 0 {
            return String(format: "%d:%0.2d", seconds, ms)
        } else {
            return String(format: "%d:%d:%0:2d", minutes, seconds, ms)
        }
    }
    
    @objc private func trackAudio() {
        let normalizedTime = Float(viewModel.audioPlayer.currentTime * 100.0 / viewModel.audioPlayer.duration)
        slider.value = normalizedTime
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = .positional

        currentTimeLabel.text = stringFromTimeInterval(interval: viewModel.audioPlayer.currentTime)
    }
    
    private func makeHideKeyboardButton() -> HideKeyboardButton {
        let button = HideKeyboardButton()
        button.addTarget(self, action: #selector(hideKeyboardSelected), for: .touchUpInside)
        return button
    }
    
    @objc private func hideKeyboardSelected() {
        view.endEditing(true)
    }
    
    private func makeKeyboardTopAnchor() -> NSLayoutConstraint {
        return noteTextView.bottomAnchor ⩵ slider.topAnchor - 80
    }
}

extension PlaybackViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.rows[indexPath.row].cell(for: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.rows[indexPath.row].height()
    }
}

extension PlaybackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.setNote(textView.text)
    }
}

extension PlaybackViewController: PlaybackViewModelDelegate {

    func updateRows() {
        tableView.updateRows()
    }
    
    func updateSlider(progress: CGFloat) {
        
    }
    
    func didPlay() {
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .semibold)
        playButton.setImage(UIImage(systemName: "stop.fill", withConfiguration: config), for: .normal)
    }
    
    func didStop() {
        let config = UIImage.SymbolConfiguration(pointSize: 64, weight: .semibold)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
    }
}

//
//  FocusSectionViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/27/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class FocusSectionRootViewController: UINavigationController {
    
    private let focusSectionViewController: FocusSectionViewController

    init(focusSectionViewController: FocusSectionViewController) {
        self.focusSectionViewController = focusSectionViewController
        super.init(nibName: nil, bundle: nil)

        viewControllers = [focusSectionViewController]
        self.makeBarTransparent()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: FocusSectionViewModel) {
        focusSectionViewController.configure(viewModel: viewModel)
    }
}

class FocusSectionViewController: SubAdagioViewController {
    
    private lazy var tableView = makeTableView()
    private lazy var hideKeyboardButton = makeHideKeyboardButton()
    private lazy var keyboardTopAnchor = makeKeyboardTopAnchor()
    private let imagePicker = UIImagePickerController()
    private var presented = false
    
    private var viewModel: FocusSectionViewModel?
    
    func configure(viewModel: FocusSectionViewModel) {
        self.viewModel = viewModel
        viewModel.delegate = self
        
        self.reloadRows()
    }
    
    override func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(hideKeyboardButton)
        hideKeyboardButton.alpha = 0
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor ⩵ view.safeAreaLayoutGuide.topAnchor,
            tableView.leftAnchor ⩵ view.leftAnchor,
            tableView.rightAnchor ⩵ view.rightAnchor,
            keyboardTopAnchor
        ])
        NSLayoutConstraint.activate([
            hideKeyboardButton.heightAnchor ⩵ 40,
            hideKeyboardButton.widthAnchor ⩵ 40,
            hideKeyboardButton.rightAnchor ⩵ view.rightAnchor - 17,
            hideKeyboardButton.bottomAnchor ⩵ tableView.bottomAnchor - 17
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentTimerState.core.addSubscriber(subscriber: self, update: FocusSectionViewController.update)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let closeConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .regular)
        let closeBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle.fill", withConfiguration: closeConfiguration), style: .plain, target: self, action: #selector(closeSelected))
        let finishBarButton = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishSelected))
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = finishBarButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.title = "0:00"
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        presented = true
    }
    
    override func willRemove(fromParent: UIViewController) {
        presented = false
    }
    
    @objc private func closeSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func finishSelected() {
        hideKeyboardSelected()
        viewModel?.sectionFinishAction()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardTopAnchor.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.2) {
                self.hideKeyboardButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardTopAnchor.constant = 0
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
        tableView.backgroundColor = UIColor.clear
        FocusSectionRow.register(tableView: tableView)
        return tableView
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
        return tableView.bottomAnchor ⩵ view.bottomAnchor
    }
}

// MARK: - tableView
extension FocusSectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel?.rows[indexPath.row].cell(for: indexPath, in: tableView) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.rows[indexPath.row].height() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: Selectable? = tableView.visibleCells[indexPath.row] as? Selectable
        cell?.select()
    }
}

// MARK: - FocusSectionViewModelDelegate
extension FocusSectionViewController: FocusSectionViewModelDelegate {
    
    func reloadRows() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateRows() {
        tableView.updateRows()
    }
    
    func set(warmUp: Bool) {
        
    }
    
    func presentRecording(with section: Section) {
        let recordingViewModel = RecordingViewModel(section: section, doneAction: {
            self.viewModel?.reloadRows()
            self.reloadRows()
        })
        let recordingViewController = RecordingViewController(viewModel: recordingViewModel)
        present(recordingViewController, animated: true, completion: nil)
    }
    
    func presentPlayback(with recording: Recording) {
        let playbackViewModel = PlaybackViewModel(section: viewModel!.section, recording: recording, reloadAction: reloadRows)
        let playbackViewController = PlaybackRootViewController(viewModel: playbackViewModel)
        present(playbackViewController, animated: true, completion: nil)
    }
    
    func present(piece: Piece) {
        let pieceViewModel = EditPieceViewModel(piece: piece, managedObjectContext: piece.managedObjectContext!, editing: false, viewOnly: true)
        let pieceViewController = EditPieceViewController(viewModel: pieceViewModel)
        let navigationController = UINavigationController(rootViewController: pieceViewController)
        navigationController.makeBarTransparent()
        present(navigationController, animated: true, completion: nil)
    }
    
    func presentImage(with viewModel: ImageViewModel) {
        present(ImageRootViewController(viewModel: viewModel), animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - Subscriber
extension FocusSectionViewController: Subscriber {
    func update(state: CurrentTimerState) {
        guard let startDate = viewModel?.section.startDate else { return }
        
        let currentInterval = floor(-startDate.timeIntervalSince(Date()))
        var currentTitle: String?

        if currentInterval < 60 {
            if currentInterval > 9 {
                currentTitle = "0:\(Int(currentInterval))"
            } else {
                currentTitle = "0:0\(Int(currentInterval))"
            }
        } else {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .dropLeading
            formatter.allowedUnits = [.second, .minute, .hour]
            currentTitle = formatter.string(from: currentInterval)
        }
        
        self.title = currentTitle
    }
}

extension FocusSectionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            self.viewModel?.add(image: image)
        }
    }
}

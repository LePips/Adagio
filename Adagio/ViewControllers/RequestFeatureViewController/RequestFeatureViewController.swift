//
//  RequestFeatureViewController.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class RequestFeatureRootViewController: UINavigationController {
    
    init(viewModel: RequestFeatureViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [RequestFeatureViewController(viewModel: viewModel)]
        self.makeBarTransparent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class RequestFeatureViewController: SubAdagioViewController {
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var textView = makeTextView()
    
    private let viewModel: RequestFeatureViewModel
    
    init(viewModel: RequestFeatureViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Request Feature"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(textView)
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor ⩵ view.safeAreaLayoutGuide.topAnchor + 5,
            titleLabel.leftAnchor ⩵ view.leftAnchor + 17,
            titleLabel.widthAnchor ⩵ view.widthAnchor × 0.66
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor ⩵ titleLabel.bottomAnchor + 15,
            descriptionLabel.leftAnchor ⩵ view.leftAnchor + 17
        ])
        NSLayoutConstraint.activate([
            textView.topAnchor ⩵ descriptionLabel.bottomAnchor + 20,
            textView.leftAnchor ⩵ view.leftAnchor + 17,
            textView.rightAnchor ⩵ view.rightAnchor - 17,
            textView.bottomAnchor ⩵ view.safeAreaLayoutGuide.bottomAnchor
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected))
        let sendBarButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(sendSelected))
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = sendBarButton
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func cancelSelected() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendSelected() {
        
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.Adagio.textColor
        label.numberOfLines = 2
        label.text = "Have an idea to make your practices better?"
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel.forAutoLayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.text = "Leave your idea below!"
        return label
    }
    
    private func makeTextView() -> UITextView {
        let textView = UITextView.forAutoLayout()
        textView.backgroundColor = UIColor.tertiarySystemBackground
        textView.layer.cornerRadius = 8.91
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return textView
    }
}

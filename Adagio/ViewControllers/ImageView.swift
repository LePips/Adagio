//
//  ImageView.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

protocol ImageViewDelegate {
    func didSelect(_ imageView: ImageView, with image: Image)
}

class ImageView: BasicView {
    
    private lazy var imageView = makeImageView()
    private lazy var notesIcon = makeNotesIcon()
    
    private var image: Image?
    private var delegate: ImageViewDelegate?
    
    func configure(image: Image, delegate: ImageViewDelegate) {
        self.image = image
        self.delegate = delegate
        imageView.image = image.image
        
        notesIcon.isHidden = image.note == nil
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSelected))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func imageSelected() {
        guard let image = image else { return }
        delegate?.didSelect(self, with: image)
    }
    
    override func setupSubviews() {
        addSubview(imageView)
        addSubview(notesIcon)
        notesIcon.isHidden = image?.note == nil
    }
    
    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor ⩵ centerXAnchor,
            imageView.topAnchor ⩵ topAnchor + 5,
            imageView.heightAnchor ⩵ 90,
            imageView.widthAnchor ⩵ 90
        ])
        NSLayoutConstraint.activate([
            notesIcon.centerXAnchor ⩵ centerXAnchor,
            notesIcon.topAnchor ⩵ imageView.bottomAnchor + 5
        ])
        NSLayoutConstraint.activate([
            widthAnchor ⩵ 100
        ])
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        imageView.tintColor = UIColor.Adagio.textColor
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    private func makeNotesIcon() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let icon = UIImage(systemName: "text.alignleft", withConfiguration: config)
        imageView.image = icon
        imageView.tintColor = UIColor.Adagio.textColor
        return imageView
    }
}

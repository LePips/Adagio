//
//  ImageCell.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

class ImageCell: BasicTableViewCell {
    
    private lazy var mainImageView = makeImageView()
    
    func configure(image: UIImage) {
        mainImageView.image = image
    }
    
    override func setupSubviews() {
        contentView.embed(mainImageView)
    }
    
    override func setupLayoutConstraints() {
        
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView.forAutoLayout()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

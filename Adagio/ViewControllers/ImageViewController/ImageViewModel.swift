//
//  ImageViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation

protocol ImageViewModelDelegate {
    
    func updateRows()
    func reloadRows()
}

class ImageViewModel {
    
    var rows: [ImageRow] {
        didSet {
            if !oldValue.difference(from: rows).isEmpty {
                delegate?.reloadRows()
            } else {
                delegate?.updateRows()
            }
        }
    }
    var image: Image
    var newImage: Image
    var editing: Bool
    var delegate: ImageViewModelDelegate?
    var deleteAction: (Image) -> Void
    var replaceAction: (Image, Image) -> Void
    
    init(image: Image, deleteAction: @escaping (Image) -> Void, replaceAction: @escaping (Image, Image) -> Void) {
        self.rows = []
        self.image = image
        self.newImage = image
        self.editing = false
        self.deleteAction = deleteAction
        self.replaceAction = replaceAction
        
        reloadRows()
    }
    
    func reloadRows() {
        self.rows = [
            .image(image.image),
            .title(TextFieldCellConfiguration(title: "Title",
                                                required: true,
                                                text: image.title,
                                                textAction: setTitle(_:),
                                                allowNewLines: false,
                                                editing: self.editing,
                                                textAutocapitalizationType: .words)),
            .note(TextFieldCellConfiguration(title: "Notes",
                                             required: false,
                                             text: image.note,
                                             textAction: setNote(_:),
                                             allowNewLines: true,
                                             editing: self.editing,
                                             returnKeyType: .default,
                                             returnAction: { _ in },
                                             textAutocapitalizationType: .sentences)),
            .spacer(100)
        ]
    }
    
    func setTitle(_ title: String) {
        self.newImage = Image(image.image, title: title, note: image.note)
        reloadRows()
    }
    
    func setNote(_ note: String) {
        self.newImage = Image(image.image, title: image.title, note: note)
        reloadRows()
    }
    
    func saveAction() {
        replaceAction(image, newImage)
    }
    
    func delete() {
        deleteAction(image)
    }
}

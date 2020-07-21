//
//  FocusSectionViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/3/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import CoreData

protocol FocusSectionViewModelDelegate {
    
    func reloadRows()
    func updateRows()
    
    func set(warmUp: Bool)
    func presentRecording(with section: Section)
    func presentPlayback(with recording: Recording)
    func presentImage(with viewModel: ImageViewModel)
    func presentImagePicker()
    func present(piece: Piece)
}

class FocusSectionViewModel {
    
    var rows: [FocusSectionRow] = []  {
           didSet {
               if !oldValue.difference(from: rows).isEmpty {
                   delegate?.reloadRows()
               } else {
                   delegate?.updateRows()
               }
           }
       }
    var delegate: FocusSectionViewModelDelegate?
    var section: Section
    var managedObjectContext: NSManagedObjectContext
    var sectionFinishAction: () -> Void
    
    init(section: Section, managedObjectContext: NSManagedObjectContext, sectionFinishAction: @escaping () -> Void) {
        self.section = section
        self.managedObjectContext = managedObjectContext
        self.sectionFinishAction = sectionFinishAction
        reloadRows()
    }
    
    func reloadRows() {
        self.rows = [
            .subtitle(section.practice.title),
            .title(TextFieldCellConfiguration(title: "", required: false, text: section.title, textAction: { _ in }, allowNewLines: false, editing: false)),
            .viewPiece(ViewPieceCellConfiguration(selectedAction: viewPieceSelected)),
            .radio(RadioCellConfiguration(title: "Warm Up", selected: section.warmUp, selectedAction: set(warmUp:))),
            .notes(TextFieldCellConfiguration(title: "Notes",
                                              required: false,
                                              text: section.note,
                                              textAction: set(note:),
                                              allowNewLines: true,
                                              returnKeyType: .default,
                                              returnAction: { _ in },
                                              textAutocapitalizationType: .sentences)),
            .recording(RecordingCellConfiguration(createAction: createRecording,
                                                  recordings: section.recordings.array as? [Recording] ?? [],
                                                  selectAction: present(recording:))),
//            .image(ImageSelectionCellConfiguration(images: section.images,
//                                                   addAction: { self.delegate?.presentImagePicker() },
//                                                   selectedAction: { image in
//                                                    self.delegate?.presentImage(with: ImageViewModel(image: image, deleteAction: self.delete(image:), replaceAction: self.replace(old:new:)))
//            },
//                                                   editing: true))
        ]
    }
    
    func set(note: String) {
        section.note = note
        delegate?.updateRows()
    }
    
    func set(warmUp: Bool) {
        section.warmUp = warmUp
        delegate?.set(warmUp: warmUp)
    }
    
    func createRecording() {
        delegate?.presentRecording(with: section)
    }
    
    func present(recording: Recording) {
        delegate?.presentPlayback(with: recording)
    }
    
    func viewPieceSelected() {
        guard let piece = section.piece else { return }
        Haptics.main.light()
        delegate?.present(piece: piece)
    }
    
    func add(image: UIImage) {
        section.images.append(Image(image, title: "Image", note: nil))
        rows[rows.count - 1] = .image(ImageSelectionCellConfiguration(images: section.images, addAction: {
                                   self.delegate?.presentImagePicker()
                                },
                                   selectedAction: { image in
                                    self.delegate?.presentImage(with: ImageViewModel(image: image, deleteAction: self.delete(image:), replaceAction: self.replace(old:new:)))
                                },
                                   editing: true))
        delegate?.reloadRows()
    }
    
    func delete(image: Image) {
        if let index = section.images.firstIndex(of: image) {
            section.images.remove(at: index)
            self.reloadRows()
            delegate?.reloadRows()
        }
    }
    
    func replace(old: Image, new: Image) {
        if let index = section.images.firstIndex(of: old) {
            section.images[index] = new
            self.reloadRows()
            delegate?.reloadRows()
        }
    }
}

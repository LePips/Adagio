//
//  EditPieceViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import CoreData

protocol EditPieceViewModelDelegate {
    
    func reloadRows()
    func updateRows()
    func dismiss()
    
    func presentInstrumentPicker(with viewModel: CoreDataPickerViewModel<Instrument>)
    func presentGroupPicker(with viewModel: CoreDataPickerViewModel<Group>)
}

protocol EditPieceViewModelProtocol: class {
    
    var rows: [EditPieceRow] { get set }
    var piece: Piece { get set }
    var managedObjectContext: NSManagedObjectContext { get set }
    var delegate: EditPieceViewModelDelegate? { get set }
    
    func reloadRows()
    
    func setTitle(_ title: String)
    func setArtist(_ artist: String)
    func setNote(_ note: String)
    
    func presentInstrumentPicker(with viewModel: CoreDataPickerViewModel<Instrument>)
    func presentGroupPicker(with viewModel: CoreDataPickerViewModel<Group>)
    
    func add(instrument: Instrument)
    func add(group: Group)
    func remove(from instrument: Instrument)
    func remove(from group: Group)
    
    func savePiece()
}

class EditPieceViewModel: EditPieceViewModelProtocol {
    
    var rows: [EditPieceRow] {
        didSet {
            if !oldValue.difference(from: rows).isEmpty {
                delegate?.reloadRows()
            } else {
                delegate?.updateRows()
            }
        }
    }
    var piece: Piece
    var managedObjectContext: NSManagedObjectContext
    var delegate: EditPieceViewModelDelegate?
    
    init(piece: Piece?, managedObjectContext: NSManagedObjectContext) {
        self.rows = []
        self.managedObjectContext = managedObjectContext
        if let piece = piece {
            self.piece = piece
            self.rows = [.title(TextFieldCellConfiguration(title: "Title", required: true, text: piece.title, textAction: setTitle(_:), allowNewLines: false)),
                         .artist(TextFieldCellConfiguration(title: "Artist/Composer", required: false, text: piece.artist, textAction: setArtist(_:), allowNewLines: false)),
                         .note(TextFieldCellConfiguration(title: "Notes", required: false, text: nil, textAction: setNote(_:), allowNewLines: true))
            ]
        } else {
            self.piece = Piece(context: managedObjectContext)
            self.rows = [.title(TextFieldCellConfiguration(title: "Title", required: true, text: nil, textAction: setTitle(_:), allowNewLines: false)),
                         .artist(TextFieldCellConfiguration(title: "Artist/Composer", required: false, text: nil, textAction: setArtist(_:), allowNewLines: false)),
                         .note(TextFieldCellConfiguration(title: "Notes", required: false, text: nil, textAction: setNote(_:), allowNewLines: true)),
                         .instruments(SelectionCellConfiguration(title: "Instruments", buttonTitle: "Add Instrument", items: [], selectionAction: {
                            let instrumentPickerViewModel = CoreDataPickerViewModel<Instrument>(title: "Add Instrument",
                                                                                                doneButtonTitle: "Add") { (instrument) in
                                                                                                    self.add(instrument: instrument)
                            }
                            self.presentInstrumentPicker(with: instrumentPickerViewModel)
                         })),
                         .groups(SelectionCellConfiguration(title: "Groups", buttonTitle: "Add Group", items: [], selectionAction: { }))
            ]
        }
    }
    
    func reloadRows() {
        self.rows = [.title(TextFieldCellConfiguration(title: "Title", required: true, text: piece.title, textAction: setTitle(_:), allowNewLines: false)),
                     .artist(TextFieldCellConfiguration(title: "Artist/Composer", required: false, text: piece.artist, textAction: setArtist(_:), allowNewLines: false)),
                     .note(TextFieldCellConfiguration(title: "Notes", required: false, text: nil, textAction: setNote(_:), allowNewLines: true)),
                     .instruments(SelectionCellConfiguration(title: "Instruments",
                                                             buttonTitle: "Add Instrument",
                                                             items: piece.instruments?.allObjects.compactMap({ ($0 as? Instrument)?.title }) ?? [],
                                                             selectionAction: {
                        let instrumentPickerViewModel = CoreDataPickerViewModel<Instrument>(title: "Add Instrument",
                                                                                            doneButtonTitle: "Add") { (instrument) in
                                                                                                self.add(instrument: instrument)
                        }
                        self.presentInstrumentPicker(with: instrumentPickerViewModel)
                     })),
                     .groups(SelectionCellConfiguration(title: "Groups", buttonTitle: "Add Group", items: [], selectionAction: { }))
        ]
    }
    
    func setTitle(_ title: String) {
        piece.title = title
        delegate?.updateRows()
    }
    
    func setArtist(_ artist: String) {
        piece.artist = artist.isEmpty ? nil : artist
        delegate?.updateRows()
    }
    
    func setNote(_ note: String) {
        piece.notes = note.isEmpty ? nil : note
        delegate?.updateRows()
    }
    
    func presentInstrumentPicker(with viewModel: CoreDataPickerViewModel<Instrument>) {
        delegate?.presentInstrumentPicker(with: viewModel)
    }
    
    func presentGroupPicker(with viewModel: CoreDataPickerViewModel<Group>) {
        delegate?.presentGroupPicker(with: viewModel)
    }
    
    func selectInstrument(title: String) {
        let fetchRequest: NSFetchRequest<Instrument> = Instrument.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        CoreDataManager.main.fetch(request: fetchRequest) { (instruments) in
            guard instruments.count == 1, instruments[0].title == title else { assertionFailure(); return }
            self.add(instrument: instruments[0])
        }
    }
    
    func selectGroup(title: String) {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        CoreDataManager.main.fetch(request: fetchRequest) { (groups) in
            guard groups.count == 1, groups[0].title == title else { assertionFailure(); return }
            self.add(group: groups[0])
        }
    }
    
    func add(instrument: Instrument) {
        guard let correctContextInstrument = managedObjectContext.object(with: instrument.objectID) as? Instrument else { assertionFailure(); return }
        piece.addToInstruments(correctContextInstrument)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func add(group: Group) {
        piece.addToGroups(group)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func remove(from instrument: Instrument)  {
        piece.removeFromInstruments(instrument)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func remove(from group: Group) {
        piece.removeFromGroups(group)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func close() {
    }
    
    func savePiece() {
        piece.save(writeToDisk: true) { (_) in
            DispatchQueue.main.async {
                self.delegate?.dismiss()
            }
        }
    }
}

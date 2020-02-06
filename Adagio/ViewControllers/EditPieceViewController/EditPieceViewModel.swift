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
    
    func didSavePiece()
    
    func presentEntryView()
    func hideEntryView()
    func reloadEntryView(practices: [Practice])
    
    func presentInstrumentPicker(with viewModel: InstrumentPickerViewModel)
    func presentGroupPicker(with viewModel: GroupPickerViewModel)
}

protocol EditPieceViewModelProtocol: class {
    
    var rows: [EditPieceRow] { get set }
    var piece: Piece { get set }
    var editing: Bool { get set }
    var isExisting: Bool { get set }
    var managedObjectContext: NSManagedObjectContext { get set }
    var delegate: EditPieceViewModelDelegate? { get set }
    
    func reloadRows()
    
    func setTitle(_ title: String)
    func setArtist(_ artist: String)
    func setNote(_ note: String)
    
    func presentInstrumentPicker(with viewModel: InstrumentPickerViewModel)
    func presentGroupPicker(with viewModel: GroupPickerViewModel)
    
    func add(instrument: Instrument)
    func add(group: Group)
    func remove(from instrument: Instrument)
    func remove(from group: Group)
    
    func close()
    func beginEditing()
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
    var editing: Bool
    var isExisting: Bool
    var managedObjectContext: NSManagedObjectContext
    var delegate: EditPieceViewModelDelegate?
    
    var practicesForPiece: [Practice] = []
    
    // MARK: - initialization
    init(piece: Piece?, managedObjectContext: NSManagedObjectContext, editing: Bool) {
        self.rows = []
        self.managedObjectContext = managedObjectContext
        self.editing = editing
        if let piece = piece {
            self.piece = piece
            self.isExisting = true
            reloadRows()
        } else {
            self.piece = Piece(context: managedObjectContext)
            self.isExisting = false
            self.rows = [.title(TextFieldCellConfiguration(title: "Title",
                                                           required: true,
                                                           text: nil,
                                                           textAction: setTitle(_:),
                                                           allowNewLines: false,
                                                           textAutocapitalizationType: .words)),
                         .segment(SegmentConfiguration(editing: true, delegate: self)),
                         .artist(TextFieldCellConfiguration(title: "Artist/Composer",
                                                            required: false,
                                                            text: nil,
                                                            textAction: setArtist(_:),
                                                            allowNewLines: false,
                                                            textAutocapitalizationType: .words)),
                         .note(TextFieldCellConfiguration(title: "Notes",
                                                          required: false,
                                                          text: nil,
                                                          textAction: setNote(_:),
                                                          allowNewLines: true,
                                                          returnKeyType: .default,
                                                          returnAction: { _ in },
                                                          textAutocapitalizationType: .sentences)),
                         .instruments(SelectionCellConfiguration(title: "Instruments",
                                                                 buttonTitle: "Add Instrument",
                                                                 items: [],
                                                                 selectionAction: {
                            let instrumentPickerViewModel = InstrumentPickerViewModel(title: "Add Instrument",doneButtonTitle: "Add", selectedAction: self.addToInstrument(title:))
                            self.presentInstrumentPicker(with: instrumentPickerViewModel)
                         })),
                         .groups(SelectionCellConfiguration(title: "Groups",
                                                            buttonTitle: "Add Group",
                                                            items: [],
                                                            selectionAction: {
                            let groupPickerViewModel = GroupPickerViewModel(title: "Add group", doneButtonTitle: "Add", selectedAction: self.addToGroup(title:))
                            self.presentGroupPicker(with: groupPickerViewModel)
                         }))
            ]
        }
    }
    
    // MARK: - reloadRows
    func reloadRows() {
        self.rows = [.title(TextFieldCellConfiguration(title: "Title",
                                                       required: true,
                                                       text: piece.title,
                                                       textAction: setTitle(_:),
                                                       allowNewLines: false,
                                                       editing: self.editing,
                                                       textAutocapitalizationType: .words)),
                     .segment(SegmentConfiguration(editing: self.editing, delegate: self)),
                     .artist(TextFieldCellConfiguration(title: "Artist/Composer",
                                                        required: false,
                                                        text: piece.artist,
                                                        textAction: setArtist(_:),
                                                        allowNewLines: false,
                                                        editing: self.editing,
                                                        textAutocapitalizationType: .words)),
                     .note(TextFieldCellConfiguration(title: "Notes",
                                                      required: false,
                                                      text: nil,
                                                      textAction: setNote(_:),
                                                      allowNewLines: true,
                                                      editing: self.editing,
                                                      returnKeyType: .default,
                                                      returnAction: { _ in },
                                                      textAutocapitalizationType: .sentences)),
                     .instruments(SelectionCellConfiguration(title: "Instruments",
                                                             buttonTitle: "Add Instrument",
                                                             items: piece.instruments?.allObjects.compactMap({ ($0 as? Instrument)?.title }).sorted() ?? [],
                                                             selectionAction: {
                                                                let instrumentPickerViewModel = InstrumentPickerViewModel(title: "Add Instrument",doneButtonTitle: "Add", selectedAction: self.addToInstrument(title:))
                                                                self.presentInstrumentPicker(with: instrumentPickerViewModel)
                     }, editing: self.editing)),
                     .groups(SelectionCellConfiguration(title: "Groups",
                                                        buttonTitle: "Add Group",
                                                        items: piece.groups?.allObjects.compactMap({ ($0 as? Group)?.title }).sorted() ?? [],
                                                        selectionAction: {
                                                            let groupPickerViewModel = GroupPickerViewModel(title: "Add group", doneButtonTitle: "Add", selectedAction: self.addToGroup(title:))
                                                            self.presentGroupPicker(with: groupPickerViewModel)
                     }, editing: self.editing))
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
    
    func presentInstrumentPicker(with viewModel: InstrumentPickerViewModel) {
        delegate?.presentInstrumentPicker(with: viewModel)
    }
    
    func presentGroupPicker(with viewModel: GroupPickerViewModel) {
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
        correctContextInstrument.addToPieces(piece)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func addToInstrument(title: String) {
        let fetchRequest: NSFetchRequest<Instrument> = Instrument.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        CoreDataManager.main.fetch(request: fetchRequest) { (objects) in
            guard objects.count == 1 else { assertionFailure(); return }
            self.add(instrument: objects[0])
        }
    }
    
    func add(group: Group) {
        guard let correctContextGroup = managedObjectContext.object(with: group.objectID) as? Group else { assertionFailure(); return }
        correctContextGroup.addToPieces(piece)
        self.reloadRows()
        delegate?.reloadRows()
    }
    
    func addToGroup(title: String) {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        CoreDataManager.main.fetch(request: fetchRequest) { (objects) in
            guard objects.count == 1 else { assertionFailure(); return }
            self.add(group: objects[0])
        }
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
        managedObjectContext.rollback()
    }
    
    func beginEditing() {
        self.editing = true
        self.reloadRows()
        self.delegate?.updateRows()
    }
    
    func savePiece() {
        self.editing = false
        self.reloadRows()
        self.isExisting = true
        
        piece.addToInstruments(piece.instruments ?? [])
        piece.addToGroups(piece.groups ?? [])
        piece.save(writeToDisk: true) { (_) in
            DispatchQueue.main.async {
                self.delegate?.didSavePiece()
            }
        }
    }
    
    func deletePiece() {
        piece.delete(writeToDisk: true) { (_) in
            NotificationCenter.default.post(name: CoreDataManager.saveNotification, object: nil)
            self.delegate?.dismiss()
        }
    }
}

// MARK: - SegmentCellDelegate
extension EditPieceViewModel: SegmentCellDelegate {
    
    func detailSelected() {
        delegate?.hideEntryView()
    }
    
    func historySelected() {
        delegate?.presentEntryView()
        
        let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
        CoreDataManager.main.fetch(request: fetchRequest) { (practices) in
            let filtered = practices.filter({ $0.sections?.compactMap({ ($0 as! Section) }).contains(where: { $0.piece == self.piece }) ?? false })
            self.practicesForPiece = filtered
            self.delegate?.reloadEntryView(practices: filtered)
        }
    }
}

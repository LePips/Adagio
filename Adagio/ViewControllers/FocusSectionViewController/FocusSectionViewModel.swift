//
//  FocusSectionViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/3/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol FocusSectionViewModelDelegate {
    
    func reloadRows()
    func updateRows()
    
    func set(warmUp: Bool)
    func presentRecording(with section: Section)
    func presentPlayback(with recording: Recording)
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
                                                  selectAction: present(recording:)))
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
}

//
//  PracticeViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation

// MARK: - PracticeViewModelDelegate
protocol PracticeViewModelDelegate {
    
    func updateRows()
    func reloadRows()
    
    func addPieceSelected()
    func deletePracticeSelected()
}

// MARK: - PracticeViewModelProtocol
protocol PracticeViewModelProtocol: class {
    
    var rows: [PracticeRow] { get set }
    var delegate: PracticeViewModelDelegate? { get set }
    var practice: Practice { get }
    var managedObjectContext: NSManagedObjectContext { get }
    
    func setTitle(_ title: String)
    func setNote(_ note: String?)
    func createRows()
    func deleteSection(_ section: Section)
    func createPieceSection(with piece: Piece) -> Section
    func focus(section: Section)
    func endFocusSection()
    func addPieceSelected()
    func deletePracticeSelected()
    func deletePracticeConfirmed()
    func saveEntry(current: Bool, completion: @escaping () -> Void)
}

// MARK: - PracticeViewModel
class PracticeViewModel: PracticeViewModelProtocol {
    
    var rows: [PracticeRow] = [] {
        didSet {
            if !oldValue.difference(from: rows).isEmpty {
                delegate?.reloadRows()
            } else {
                delegate?.updateRows()
            }
        }
    }
    var delegate: PracticeViewModelDelegate?
    var practice: Practice
    var managedObjectContext: NSManagedObjectContext
    var focusedSection: Section?
    
    init(practice: Practice, managedObjectContext: NSManagedObjectContext) {
        self.practice = practice
        practice.title = "Evening Practice"
        self.managedObjectContext = managedObjectContext
        createRows()
    }
    
    func setTitle(_ title: String) {
        practice.title = title
        delegate?.updateRows()
    }
    
    func setNote(_ note: String?) {
        practice.note = note
        delegate?.updateRows()
    }
    
    func createRows() {
        self.rows = [.title(TextFieldCellConfiguration(title: "", required: false, text: practice.title, textAction: setTitle(_:), allowNewLines: false, textAutocapitalizationType: .words)),
                     .subtitle,
                     .notes(TextFieldCellConfiguration(title: "Notes",
                                                       required: false,
                                                       text: practice.note,
                                                       textAction: setNote(_:),
                                                       allowNewLines: true,
                                                       returnKeyType: .default,
                                                       returnAction: { _ in },
                                                       textAutocapitalizationType: .sentences)),
                     .spacer(20)
        ]
        
        for section in practice.sections ?? [] {
            self.rows.append(.section(section as! Section))
        }
        
        self.rows.append(contentsOf: [
            .addPiece(AddPieceConfiguration(selectedAction: addPieceSelected)),
            .deletePractice(DeletePracticeConfiguration(selectedAction: deletePracticeSelected))
        ])
    }
    
    func deleteSection(_ section: Section) {
        
    }
    
    func createPieceSection(with piece: Piece) -> Section {
        guard let currentContextPiece = managedObjectContext.object(with: piece.objectID) as? Piece else { fatalError() }
        let newSection = Section(context: managedObjectContext)
        newSection.title = piece.title
        newSection.piece = currentContextPiece
        newSection.startDate = Date()
        practice.addToSections(newSection)
        createRows()
        return newSection
    }
    
    func focus(section: Section) {
        self.focusedSection = section
        CurrentPracticeState.core.fire(.focus(section))
    }
    
    func endFocusSection() {
        focusedSection?.endDate = Date()
        self.focusedSection = nil
        CurrentPracticeState.core.fire(.endFocusSection)
    }
    
    func addPieceSelected() {
        delegate?.addPieceSelected()
    }
    
    func deletePracticeSelected() {
        delegate?.deletePracticeSelected()
    }
    
    func deletePracticeConfirmed() {
        CurrentPracticeState.core.fire(.deleteCurrentPractice(nil))
    }
    
    func saveEntry(current: Bool, completion: @escaping () -> Void) {
        CurrentPracticeState.core.fire(.saveCurrentPractice)
    }
}

// MARK: - ViewPracticeViewModel
class ViewPracticeViewModel: PracticeViewModelProtocol {
    
    var rows: [PracticeRow] = []
    var delegate: PracticeViewModelDelegate?
    var practice: Practice
    var managedObjectContext: NSManagedObjectContext
    
    init(practice: Practice) {
        self.practice = practice
        self.managedObjectContext = practice.managedObjectContext!
        
        createRows()
        delegate?.reloadRows()
    }
    
    func setTitle(_ title: String) {
        
    }
    
    func setNote(_ note: String?) {
        
    }
    
    func createRows() {
        self.rows = [.title(TextFieldCellConfiguration(title: "", required: false, text: practice.title, textAction: setTitle(_:), allowNewLines: false, textAutocapitalizationType: .words)),
                     .subtitle,
                     .notes(TextFieldCellConfiguration(title: "Notes",
                                                       required: false,
                                                       text: practice.note,
                                                       textAction: setNote(_:),
                                                       allowNewLines: true,
                                                       returnKeyType: .default,
                                                       returnAction: { _ in },
                                                       textAutocapitalizationType: .sentences)),
                     .spacer(20)
        ]
        
        for section in practice.sections ?? [] {
            self.rows.append(.section(section as! Section))
        }
    }
    
    func deleteSection(_ section: Section) {
        
    }
    
    func createPieceSection(with piece: Piece) -> Section {
        return Section()
    }
    
    func focus(section: Section) {
        
    }
    
    func endFocusSection() {
        
    }
    
    func addPieceSelected() {
        
    }
    
    func deletePracticeSelected() {
        
    }
    
    func deletePracticeConfirmed() {
        
    }
    
    func saveEntry(current: Bool, completion: @escaping () -> Void) {
        
    }
}

//
//  PracticeViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation

protocol PracticeViewModelDelegate {
    
    func updateRows()
    func reloadRows()
    
    func addPieceSelected()
    func deletePracticeSelected()
}

protocol PracticeViewModelProtocol: class {
    
    var rows: [PracticeRow] { get set }
    var duration: TimeInterval { get set }
    var delegate: PracticeViewModelDelegate? { get set }
    var practice: Practice { get }
    var managedObjectContext: NSManagedObjectContext { get }
    
    func setTitle(_ title: String)
    func setNote(_ note: String?)
    func createRows()
    func deleteSection(_ section: Section)
    func createPieceSection(with piece: Piece)
    func saveEntry(current: Bool, completion: @escaping () -> Void)
}

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
    var duration: TimeInterval = 0
    var delegate: PracticeViewModelDelegate?
    var practice: Practice
    var managedObjectContext: NSManagedObjectContext
    
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
                     .addPiece(AddPieceConfiguration(selectedAction: addPieceSelected)),
                     .deletePractice(DeletePracticeConfiguration(selectedAction: deletePracticeSelected))
        ]
    }
    
    func deleteSection(_ section: Section) {
        
    }
    
    func createPieceSection(with piece: Piece) {
        guard let currentContextPiece = managedObjectContext.object(with: piece.objectID) as? Piece else { return }
        print(currentContextPiece.title)
    }
    
    func addPieceSelected() {
        delegate?.addPieceSelected()
    }
    
    func deletePracticeSelected() {
        delegate?.deletePracticeSelected()
    }
    
    func deletePracticeConfirmed() {
        practice.delete(writeToDisk: true, completion: nil)
    }
    
    func saveEntry(current: Bool, completion: @escaping () -> Void) {
        
    }
}

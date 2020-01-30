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
        self.rows = [.title(TextFieldCellConfiguration(title: "", required: false, text: practice.title, textAction: setTitle(_:), allowNewLines: false)),
                     .subtitle,
                     .notes(TextFieldCellConfiguration(title: "Notes", required: false, text: nil, textAction: setNote(_:), allowNewLines: true)),
                     .addPiece(AddPieceConfiguration(selectedAction: addPieceSelected))
        ]
    }
    
    func deleteSection(_ section: Section) {
        
    }
    
    func createPieceSection(with piece: Piece) {
        
    }
    
    func addPieceSelected() {
        delegate?.addPieceSelected()
    }
    
    func saveEntry(current: Bool, completion: @escaping () -> Void) {
        
    }
}

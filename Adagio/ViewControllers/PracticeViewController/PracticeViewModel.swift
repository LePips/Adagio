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
    func setSectionWarmUp(_ section: Section, warmUp: Bool)
    func addNoteToSection(_ section: Section)
    func setNoteTo(_ section: Section, note: String?)
    func otherSelected(on section: Section)
    func createPieceSection(with piece: Piece)
    func saveEntry(current: Bool, completion: @escaping () -> Void)
}

class PracticeViewModel: PracticeViewModelProtocol {
    
    var rows: [PracticeRow] = []
    var duration: TimeInterval = 0
    var delegate: PracticeViewModelDelegate?
    var practice: Practice
    var managedObjectContext: NSManagedObjectContext
    
    init(practice: Practice, managedObjectContext: NSManagedObjectContext) {
        self.practice = practice
        self.managedObjectContext = managedObjectContext
    }
    
    func setTitle(_ title: String) {
        
    }
    
    func setNote(_ note: String?) {
        
    }
    
    func createRows() {
        
    }
    
    func deleteSection(_ section: Section) {
        
    }
    
    func setSectionWarmUp(_ section: Section, warmUp: Bool) {
        
    }
    
    func addNoteToSection(_ section: Section) {
        
    }
    
    func setNoteTo(_ section: Section, note: String?) {
        
    }
    
    func otherSelected(on section: Section) {
        
    }
    
    func createPieceSection(with piece: Piece) {
        
    }
    
    func saveEntry(current: Bool, completion: @escaping () -> Void) {
        
    }
}

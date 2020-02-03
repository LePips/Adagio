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
    
}

class FocusSectionViewModel {
    
    var rows: [FocusSectionRow] = []
    var delegate: FocusSectionViewModelDelegate?
    var section: Section
    var managedObjectContext: NSManagedObjectContext
    
    init(section: Section, managedObjectContext: NSManagedObjectContext) {
        self.section = section
        self.managedObjectContext = managedObjectContext
    }
    
}

//
//  PickerViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol Titlable {
    var title: String { get set }
}

class CoreDataPickerViewModel<ObjectType: NSManagedObject & Titlable> {
    
    var title: String
    var doneButtonTitle: String
    var objects: [ObjectType] = []
    var selectedAction: (ObjectType) -> Void
    
    init(title: String, doneButtonTitle: String, selectedAction: @escaping (ObjectType) -> Void) {
        self.title = title
        self.doneButtonTitle = doneButtonTitle
        self.selectedAction = selectedAction
        
        let fetchRequest = ObjectType.fetchRequest() as! NSFetchRequest<ObjectType>
        CoreDataManager.main.fetch(request: fetchRequest) { (objects) in
            self.objects = objects
        }
    }
}

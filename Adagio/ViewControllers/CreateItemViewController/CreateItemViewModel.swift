//
//  CreateItemViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation

protocol CreateItemViewModelDelegate {
    
    func itemSaved()
}

protocol CreateItemViewModelProtocol: class {
    
    associatedtype ObjectType: NSManagedObject & Titlable
    
    var title: String { get set }
    var doneButtonTitle: String { get set }
    var text: String? { get set }
    var itemDidSaveAction: ((String) -> Void)? { get set }
    var delegate: CreateItemViewModelDelegate? { get set }
    
    func set(text: String?)
    
    func saveItem()
}

class CreateItemViewModel<ObjectType: NSManagedObject & Titlable>: CreateItemViewModelProtocol {
    
    var title: String
    var doneButtonTitle: String
    var text: String?
    var itemDidSaveAction: ((String) -> Void)?
    var delegate: CreateItemViewModelDelegate?
    
    init(title: String, doneButtonTitle: String) {
        self.title = title
        self.doneButtonTitle = doneButtonTitle
    }
    
    func set(text: String?) {
        self.text = text
    }
    
    func saveItem() {
        guard let text = text, !text.isEmpty else { assertionFailure(); return }
        let managedObjectContext = CoreDataManager.main.privateChildManagedObjectContext()
        var newObject = ObjectType(context: managedObjectContext)
        newObject.title = text
        
        CoreDataManager.main.save(object: newObject) { (result) in
            switch result {
            case .success(let object):
                guard let titlableObject = object as? Titlable else { return }
                self.itemDidSaveAction?(titlableObject.title)
                self.delegate?.itemSaved()
            case .failure(_): ()
            }
        }
    }
}

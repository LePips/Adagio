//
//  PickerViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol PickerViewModelDelegate {

    func reloadRows()
    
    func selectItem(withTitle: String)
    
    func presentCreateInstrumentViewController(with viewModel: CreateItemViewModel<Instrument>)
    func presentCreateGroupViewController(with viewModel: CreateItemViewModel<Group>)
}

protocol CoreDataPickerViewModelProtocol: class {

    var title: String { get set }
    var doneButtonTitle: String { get set }
    var objects: [String] { get set }
    var selectedAction: (String) -> Void { get set }
    var delegate: PickerViewModelDelegate? { get set }

    func reloadRows()
    
    func createItem()
}

class InstrumentPickerViewModel: CoreDataPickerViewModelProtocol {
    
    var title: String
    var doneButtonTitle: String
    var objects: [String] = []
    var selectedAction: (String) -> Void
    var delegate: PickerViewModelDelegate?
    
    init(title: String, doneButtonTitle: String, selectedAction: @escaping (String) -> Void) {
        self.title = title
        self.doneButtonTitle = doneButtonTitle
        self.selectedAction = selectedAction
        
        reloadRows()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    @objc func reloadRows() {
        let fetchRequest: NSFetchRequest<Instrument> = Instrument.fetchRequest()
        CoreDataManager.main.fetch(request: fetchRequest) { (objects) in
            self.objects = objects.compactMap({ $0.title })
            self.delegate?.reloadRows()
        }
    }
    
    func createItem() {
        let createInstrumentViewModel = CreateItemViewModel<Instrument>(title: "Create Instrument", doneButtonTitle: "Create")
        createInstrumentViewModel.itemDidSaveAction = self.delegate?.selectItem(withTitle:)
        delegate?.presentCreateInstrumentViewController(with: createInstrumentViewModel)
    }
}

class GroupPickerViewModel: CoreDataPickerViewModelProtocol {
    
    var title: String
    var doneButtonTitle: String
    var objects: [String] = []
    var selectedAction: (String) -> Void
    var delegate: PickerViewModelDelegate?
    
    init(title: String, doneButtonTitle: String, selectedAction: @escaping (String) -> Void) {
        self.title = title
        self.doneButtonTitle = doneButtonTitle
        self.selectedAction = selectedAction
        
        reloadRows()
    }
    
    @objc func reloadRows() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        CoreDataManager.main.fetch(request: fetchRequest) { (objects) in
            self.objects = objects.compactMap({ $0.title })
            self.delegate?.reloadRows()
        }
    }
    
    func createItem() {
        let createGroupViewModel = CreateItemViewModel<Group>(title: "Create Group", doneButtonTitle: "Create")
        createGroupViewModel.itemDidSaveAction = self.delegate?.selectItem(withTitle:)
        delegate?.presentCreateGroupViewController(with: createGroupViewModel)
    }
}

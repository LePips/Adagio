//
//  ItemsViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol EditItemsViewModelDelegate {
    
    func reloadRows()
    
    func presentCreateInstrumentViewController(with viewModel: CreateItemViewModel<Instrument>)
    func presentCreateGroupViewController(with viewModel: CreateItemViewModel<Group>)
}

protocol EditItemsViewModelProtocol: class {
    
    var title: String { get set }
    var rows: [EditItemRow] { get set }
    var delgate: EditItemsViewModelDelegate? { get set }
    var searchQuery: String { get set }
    
    func reloadRows()
    
    func createItem()
}

class EditInstrumentsViewModel: EditItemsViewModelProtocol {
    
    var title: String = "Instruments"
    var _rows: [EditItemRow] = []
    var searchQuery = ""
    var rows: [EditItemRow] {
        get {
            if !searchQuery.isEmpty {
                return _rows.compactMap { (row) -> EditItemRow? in
                    if case let EditItemRow.instrument(instrument) = row {
                        return instrument.title.contains(searchQuery) ? row : nil
                    }
                    return nil
                }
            } else {
                return _rows
            }
        }
        set {
            _rows = newValue
        }
    }
    var delgate: EditItemsViewModelDelegate?
    
    init() {
        reloadRows()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    @objc func reloadRows() {
        let fetchRequest: NSFetchRequest<Instrument> = Instrument.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        CoreDataManager.main.fetch(request: fetchRequest) { (instruments) in
            var subtitle: String
            if instruments.count == 1 {
                subtitle = "1 instrument"
            } else {
                subtitle = "\(instruments.count) instruments"
            }
            
            var newRows: [EditItemRow] = [.subtitle(subtitle), .spacer(30)]
            newRows.append(contentsOf: instruments.compactMap({ EditItemRow.instrument($0) }))
            self.rows = newRows
            self.delgate?.reloadRows()
        }
    }
    
    func createItem() {
        let createInstrumentViewModel = CreateItemViewModel<Instrument>(title: "Create Instrument", doneButtonTitle: "Create")
        self.delgate?.presentCreateInstrumentViewController(with: createInstrumentViewModel)
    }
}

class EditGroupsViewModel: EditItemsViewModelProtocol {
    
    var title: String = "Groups"
        var _rows: [EditItemRow] = []
    var searchQuery = ""
    var rows: [EditItemRow] {
        get {
            if !searchQuery.isEmpty {
                return _rows.compactMap { (row) -> EditItemRow? in
                    if case let EditItemRow.group(group) = row {
                        return group.title.contains(searchQuery) ? row : nil
                    }
                    return nil
                }
            } else {
                return _rows
            }
        }
        set {
            _rows = newValue
        }
    }
    var delgate: EditItemsViewModelDelegate?
    
    init() {
        reloadRows()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    @objc func reloadRows() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        CoreDataManager.main.fetch(request: fetchRequest) { (groups) in
            var subtitle: String
            if groups.count == 1 {
                subtitle = "1 group"
            } else {
                subtitle = "\(groups.count) groups"
            }
            
            var newRows: [EditItemRow] = [.subtitle(subtitle), .spacer(30)]
            newRows.append(contentsOf: groups.compactMap({ EditItemRow.group($0) }))
            self.rows = newRows
            self.delgate?.reloadRows()
        }
    }
    
    func createItem() {
        let createGroupViewModel = CreateItemViewModel<Group>(title: "Create Group", doneButtonTitle: "Create")
        self.delgate?.presentCreateGroupViewController(with: createGroupViewModel)
    }
}

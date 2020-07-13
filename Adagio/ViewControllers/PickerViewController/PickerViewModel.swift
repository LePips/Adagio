//
//  PickerViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import UIKit
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
    func getCreateItemViewController(doneAction: @escaping () -> Void) -> UIViewController
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
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
    
    func getCreateItemViewController(doneAction: @escaping () -> Void) -> UIViewController {
        let viewModel = CreateItemViewModel<Instrument>(title: "Create Instrument", doneButtonTitle: "Create")
        let alertViewController = UIAlertController(title: "Create Instrument", message: nil, preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.enablesReturnKeyAutomatically = true
            textField.returnKeyType = .done
            textField.addTarget(alertViewController, action: #selector(alertViewController.textDidChangeNotEmpty), for: .editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { _ in doneAction() })
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            viewModel.set(text: alertViewController.textFields?.first?.text)
            viewModel.saveItem()
            doneAction()
        }
        createAction.isEnabled = false
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(createAction)
        
        viewModel.itemDidSaveAction = self.delegate?.selectItem(withTitle:)
        return alertViewController
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
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
    
    func getCreateItemViewController(doneAction: @escaping () -> Void) -> UIViewController {
        let viewModel = CreateItemViewModel<Group>(title: "Create Group", doneButtonTitle: "Create")
        let alertViewController = UIAlertController(title: "Create Group", message: nil, preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.enablesReturnKeyAutomatically = true
            textField.returnKeyType = .done
            textField.addTarget(alertViewController, action: #selector(alertViewController.textDidChangeNotEmpty), for: .editingChanged)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {_ in doneAction()})
        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            viewModel.set(text: alertViewController.textFields?.first?.text)
            viewModel.saveItem()
            doneAction()
        }
        createAction.isEnabled = false
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(createAction)
        
        viewModel.itemDidSaveAction = self.delegate?.selectItem(withTitle:)
        return alertViewController
    }
}

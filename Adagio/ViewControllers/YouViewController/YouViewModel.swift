//
//  YouViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation

protocol YouViewModelDelegate {
    
    func reloadRows()
}

protocol YouViewModelProtocol: class {
    
    var rows: [YouRow] { get set }
    var delegate: YouViewModelDelegate? { get set }
    
    func reloadRows()
}

class YouViewModel: YouViewModelProtocol {
    
    var rows: [YouRow] = []
    var delegate: YouViewModelDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadRows() {
        let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        CoreDataManager.main.fetch(request: fetchRequest) { (practices) in
            self.rows = YouRow.buildRows(practices: practices)
            self.delegate?.reloadRows()
        }
    }
}

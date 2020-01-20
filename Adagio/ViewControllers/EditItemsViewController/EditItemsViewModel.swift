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
}

protocol EditItemsViewModelProtocol: class {
    
    var title: String { get set }
    var rows: [EditItemRow] { get set }
    var delgate: EditItemsViewModelDelegate? { get set }
    
    func reloadRows()
}

class EditInstrumentsViewModel: EditItemsViewModelProtocol {
    
    var title: String = "Instruments"
    var rows: [EditItemRow] = [.subtitle("0 instruments")]
    var delgate: EditItemsViewModelDelegate?
    
    init() {
        reloadRows()
    }
    
    func reloadRows() {
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
}

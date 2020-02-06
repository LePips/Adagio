//
//  HomeViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

protocol HomeViewModelDelegate {
    func reloadRows()
}

protocol HomeViewModelProtocol: class {
    
    var rows: [HomeRow] { get set }
    var delegate: HomeViewModelDelegate? { get set }
    
    func reloadRows()
}

class HomeViewModel: HomeViewModelProtocol {
    
    var rows: [HomeRow] = []
    var delegate: HomeViewModelDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: CoreDataManager.saveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadRows() {
        let calendar = Calendar.current
        guard let startDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date(), matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .backward) else { assertionFailure(); return }
        guard let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date(), matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward) else { assertionFailure(); return }

        let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", startDate as NSDate, endDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        CoreDataManager.main.fetch(request: fetchRequest) { (practices) in
            self.rows = HomeRow.buildRows(practices: practices)
            self.delegate?.reloadRows()
        }
    }
}

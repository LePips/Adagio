//
//  CurrentPracticeState.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation
import SharedPips

enum CurrentPracticeChange {
    case startNewPractice(Practice, NSManagedObjectContext)
    case saveCurrentPractice
    case loadCurrentPractice
    case endPractice(((Result<Bool, Error>) -> Void)?)
}

fileprivate var sharedCore: Core<CurrentPracticeState> = {
    return Core(state: CurrentPracticeState())
}()

struct CurrentPracticeState: State {
    
    typealias EventType = CurrentPracticeChange
    
    var practice: Practice?
    var managedObjectContext: NSManagedObjectContext?
    
    mutating func respond(to event: CurrentPracticeChange) {
        switch event {
        case .startNewPractice(let newPractice, let managedObjectContext):
            newPractice.startDate = Date()
            self.practice = newPractice
            self.managedObjectContext = managedObjectContext
        case .saveCurrentPractice:
            guard let practice = practice else { return }
            UserDefaults.standard.currentSessionDate = practice.startDate
            practice.save(writeToDisk: true, completion: nil)
        case .loadCurrentPractice:
            guard practice != nil else { return }
            guard let startDate = UserDefaults.standard.currentSessionDate else { return }
            let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
            let predicate = NSPredicate(format: "startDate == %@", startDate as NSDate)
            fetchRequest.predicate = predicate
        CoreDataManager.main.fetch(request: fetchRequest) { (practices) in
            guard let currentPractice = practices.first, practices.count == 1 else { return }
            let privateContext = CoreDataManager.main.privateChildManagedObjectContext()
            guard let privateContextObject = privateContext.object(with: currentPractice.objectID) as? Practice else { return }
            CurrentPracticeState.core.fire(.startNewPractice(privateContextObject, privateContext))
            }
        case .endPractice(_):
            ()
//            practice?.save(writeToDisk: true, completion: completion)
        }
    }
    
    static var core: Core<CurrentPracticeState> {
        return sharedCore
    }
}

extension UserDefaults {
    
    var currentSessionDate: Date? {
        get {
            return self.object(forKey: "currentSessionDate") as? Date
        }
        set {
            self.set(newValue, forKey: "currentSessionDate")
        }
    }
}

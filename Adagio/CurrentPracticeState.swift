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

// MARK: - CurrentPracticeChange
enum CurrentPracticeChange {
    case startNewPractice(Practice, NSManagedObjectContext)
    case saveCurrentPractice
    case loadCurrentPractice
    case deleteCurrentPractice(((Result<Bool, Error>) -> Void)?)
    case endPractice(Practice)
    case focus(Section)
    case endFocusSection
    case forceEndPractice
    
    case loadExistingPractice(Practice, NSManagedObjectContext)
}

// MARK: - sharedCore
fileprivate var sharedCore: Core<CurrentPracticeState> = {
    return Core(state: CurrentPracticeState())
}()

// MARK: - CurrentPracticeState
struct CurrentPracticeState: State {
    
    typealias EventType = CurrentPracticeChange
    
    var practice: Practice?
    var section: Section?
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - respond
    mutating func respond(to event: CurrentPracticeChange) {
        switch event {
        case .startNewPractice(let newPractice, let managedObjectContext):
            newPractice.startDate = Date()
            self.practice = newPractice
            self.managedObjectContext = managedObjectContext
            UserDefaults.standard.inSession = true
            CurrentTimerState.core.fire(.start(newPractice.startDate))
        case .saveCurrentPractice:
            guard let practice = practice else { return }
            practice.save(writeToDisk: true, completion: nil)
        case .loadCurrentPractice:
            guard practice == nil else { return }
            guard UserDefaults.standard.inSession else { return }
            let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            CoreDataManager.main.fetch(request: fetchRequest) { (practices) in
                guard let firstPractice = practices.first, practices.count == 1 else { UserDefaults.standard.inSession = false; return }
                let privateContext = CoreDataManager.main.privateChildManagedObjectContext()
                guard let privateContextObject = privateContext.object(with: firstPractice.objectID) as? Practice else { return }
                CurrentPracticeState.core.fire(.loadExistingPractice(privateContextObject, privateContext))
            }
        case .deleteCurrentPractice(let completion):
            self.practice?.delete(writeToDisk: true, completion: completion)
            self.practice = nil
            self.managedObjectContext = nil
            UserDefaults.standard.inSession = false
            CurrentTimerState.core.fire(.reset)
        case .endPractice(_):
            practice?.endDate = Date()
            practice?.save(writeToDisk: true, completion: nil)
            UserDefaults.standard.inSession = false
            self.practice = nil
            self.managedObjectContext = nil
            Haptics.main.success()
            CurrentTimerState.core.fire(.reset)
        case .focus(let section):
            self.section = section
        case .endFocusSection:
            self.section = nil
            
        case .loadExistingPractice(let practice, let managedObjectContext):
            self.practice = practice
            self.managedObjectContext = managedObjectContext
            UserDefaults.standard.inSession = true
            CurrentTimerState.core.fire(.start(practice.startDate))
            
        case .forceEndPractice:
            practice?.endDate = Date()
            practice?.save(writeToDisk: true, completion: nil)
            UserDefaults.standard.inSession = false
            self.practice = nil
            self.managedObjectContext = nil
            CurrentTimerState.core.fire(.reset)
        }
    }
    
    // MARK: - core
    static var core: Core<CurrentPracticeState> {
        return sharedCore
    }
}

// MARK: - UserDefaults
fileprivate extension UserDefaults {
    
    var inSession: Bool {
        get {
            return self.bool(forKey: "inSession")
        }
        set {
            self.set(newValue, forKey: "inSession")
        }
    }
}

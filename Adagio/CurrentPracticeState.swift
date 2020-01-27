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
    case startPractice(Practice)
    case saveCurrentPractice
    case loadCurrentPractice
    case endPractice(((Result<Bool, Error>) -> Void)?)
}

fileprivate var sharedCore: Core<CurrentPracticeState> {
    return Core(state: CurrentPracticeState())
}

struct CurrentPracticeState: State {
    
    typealias EventType = CurrentPracticeChange
    
    var practice: Practice?
    
    mutating func respond(to event: CurrentPracticeChange) {
        switch event {
        case .startPractice(let practice):
            self.practice = practice
        case .saveCurrentPractice:
            assert(practice != nil)
            UserDefaults.standard.currentPracticeID = practice?.objectID.uriRepresentation()
            practice?.save(writeToDisk: true, completion: nil)
        case .loadCurrentPractice: ()
//            guard let currentPracticeID = UserDefaults.standard.currentPracticeID?.absoluteString else { return }
//            let fetchRequest: NSFetchRequest<Practice> = Practice.fetchRequest()
//            let predicate = NSPredicate(format: "objectID.uriRepresentation = %@", currentPracticeID)
//            fetchRequest.predicate = predicate
        case .endPractice(_):
            UserDefaults.standard.currentPracticeID = nil
//            practice?.save(writeToDisk: true, completion: completion)
        }
    }
    
    static var core: Core<CurrentPracticeState> {
        return sharedCore
    }
}

extension UserDefaults {
    
    var currentPracticeID: URL? {
        get {
            return UserDefaults.standard.url(forKey: "currentPracticeID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentPracticeID")
        }
    }
}

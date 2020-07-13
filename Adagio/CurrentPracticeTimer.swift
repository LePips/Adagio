//
//  CurrentPracticeTimer.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/2/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import SharedPips

enum TimerChange {
    case secondElapsed(Date)
    case start(Date)
    case pause
    case unpause
    case reset
}

fileprivate var sharedCore: Core<CurrentTimerState> = {
    return Core(state: CurrentTimerState())
}()

struct CurrentTimerState: State {
    
    typealias EventType = TimerChange
    
    var currentDate: Date? {
        return CurrentPracticeTimer.main.currentDate
    }
    var currentStartDate: Date? {
        return CurrentPracticeTimer.main.currentStartDate
    }
    var currentInterval: TimeInterval {
        return CurrentPracticeTimer.main.currentInterval
    }
    
    mutating func respond(to event: TimerChange) {
        switch event {
        case .secondElapsed(_): ()
        case .start(let startDate):
            CurrentPracticeTimer.main.start(from: startDate)
        case .pause:
            CurrentPracticeTimer.main.pause()
        case .unpause:
            CurrentPracticeTimer.main.unpause()
        case .reset:
            CurrentPracticeTimer.main.reset()
        }
    }
    
    static var core: Core<CurrentTimerState> {
        return sharedCore
    }
}

fileprivate class CurrentPracticeTimer {
    
    static let main = CurrentPracticeTimer()
    
    private(set) var currentStartDate: Date?
    private(set) var currentInterval: TimeInterval = 0
    private var timer: Timer?
    var currentDate: Date? {
        return currentStartDate?.addingTimeInterval(currentInterval)
    }
    
    private init() {
    }
    
    func start(from date: Date) {
        self.currentStartDate = date
        let existingInterval = DateInterval(start: date, end: Date()).duration
        self.currentInterval = existingInterval
        
        DispatchQueue.global(qos: .background).async {
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.secondElapsed), userInfo: nil, repeats: true)
            let runLoop = RunLoop.current
            self.timer = timer
            runLoop.add(timer, forMode: .default)
            runLoop.run()
        }
    }
    
    @objc private func secondElapsed() {
        currentInterval += 1
        CurrentTimerState.core.fire(.secondElapsed(currentDate ?? Date()))
    }
    
    func pause() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func unpause() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.secondElapsed()
        })
        guard let timer = self.timer else { return }
        RunLoop.main.add(timer, forMode: .default)
    }
    
    func reset() {
        self.pause()
        currentStartDate = nil
        currentInterval = 0
    }
}

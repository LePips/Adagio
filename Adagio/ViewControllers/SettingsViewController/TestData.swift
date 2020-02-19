//
//  TestData.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/4/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation
import CoreData

struct TestData {
    
    private var pieces: [Piece] {
        let objectContext = CoreDataManager.main.mainManagedObjectContext
        
        let violin = Instrument(context: objectContext)
        violin.title = "Violin"
        
        let piano = Instrument(context: objectContext)
        piano.title = "Piano"
        
        let symphony = Group(context: objectContext)
        symphony.title = "Symphony"
        
        let scales = Group(context: objectContext)
        scales.title = "Scales"
        
        let p1 = Piece(context: objectContext)
        p1.title = "Beethoven's 9th Symphony"
        p1.addToInstruments(violin)
        p1.addToInstruments(piano)
        p1.addToGroups(symphony)
        p1.images = []
        
        let p2 = Piece(context: objectContext)
        p2.title = "C Major Scales"
        p2.addToInstruments(violin)
        p2.addToGroups(scales)
        p2.images = []
        
        return [p1, p2]
    }
    
    private var practices: [Practice] {
        let objectContext = CoreDataManager.main.mainManagedObjectContext
        let calendar = Calendar.current
        
        let yesterdayPractice = Practice(context: objectContext)
        yesterdayPractice.title = "Morning Practice"
        
        let today = Date()
        guard let yesterday = calendar.date(bySetting: .day, value: calendar.component(.day, from: today) - 1, of: Date()) else { return [] }
        guard let yesterdayFinal = calendar.date(bySettingHour: 8, minute: 30, second: 0, of: yesterday) else { return [] }
        yesterdayPractice.startDate = yesterdayFinal
        yesterdayPractice.endDate = calendar.date(byAdding: .minute, value: 45, to: yesterdayFinal)
        yesterdayPractice.note = "Felt pretty good about the scales.\nNeed to get better intonation and wrist extended further from the bridge.\nDon't press the fingers down so hard on the strings"
        
        let todayPractice = Practice(context: objectContext)
        todayPractice.title = "Noon Practice"
        guard let noonish = calendar.date(bySettingHour: 12, minute: 15, second: 0, of: Date()) else { return [] }
        todayPractice.startDate = noonish
        todayPractice.endDate = calendar.date(byAdding: .minute, value: 30, to: noonish)
        todayPractice.note = "Better intonation on scales, felt okay on vabrato"
        
        return [yesterdayPractice, todayPractice]
    }
    
    static func setTestData() {
        let testData = TestData()
        let _ = testData.pieces
        let _ = testData.practices
        CoreDataManager.main.saveChanges()
    }
}

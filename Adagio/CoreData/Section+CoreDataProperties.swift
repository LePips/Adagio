//
//  Section+CoreDataProperties.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var note: String?
    @NSManaged public var title: String
    @NSManaged public var warmUp: Bool
    @NSManaged public var piece: Piece?
    @NSManaged public var practice: Practice
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var recordings: NSOrderedSet
    @NSManaged public var images: [Image]

}

// MARK: Generated accessors for recordings
extension Section {

    @objc(insertObject:inRecordingsAtIndex:)
    @NSManaged public func insertIntoRecordings(_ value: Recording, at idx: Int)

    @objc(removeObjectFromRecordingsAtIndex:)
    @NSManaged public func removeFromRecordings(at idx: Int)

    @objc(insertRecordings:atIndexes:)
    @NSManaged public func insertIntoRecordings(_ values: [Recording], at indexes: NSIndexSet)

    @objc(removeRecordingsAtIndexes:)
    @NSManaged public func removeFromRecordings(at indexes: NSIndexSet)

    @objc(replaceObjectInRecordingsAtIndex:withObject:)
    @NSManaged public func replaceRecordings(at idx: Int, with value: Recording)

    @objc(replaceRecordingsAtIndexes:withRecordings:)
    @NSManaged public func replaceRecordings(at indexes: NSIndexSet, with values: [Recording])

    @objc(addRecordingsObject:)
    @NSManaged public func addToRecordings(_ value: Recording)

    @objc(removeRecordingsObject:)
    @NSManaged public func removeFromRecordings(_ value: Recording)

    @objc(addRecordings:)
    @NSManaged public func addToRecordings(_ values: NSOrderedSet)

    @objc(removeRecordings:)
    @NSManaged public func removeFromRecordings(_ values: NSOrderedSet)

}

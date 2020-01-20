//
//  Piece+CoreDataProperties.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension Piece {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Piece> {
        return NSFetchRequest<Piece>(entityName: "Piece")
    }

    @NSManaged public var artist: String?
    @NSManaged public var images: [UIImage]?
    @NSManaged public var title: String
    @NSManaged public var notes: String?
    @NSManaged public var sections: NSSet?
    @NSManaged public var instruments: NSSet?
    @NSManaged public var groups: NSSet?

}

// MARK: Generated accessors for sections
extension Piece {

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSSet)

}

// MARK: Generated accessors for instruments
extension Piece {

    @objc(addInstrumentsObject:)
    @NSManaged public func addToInstruments(_ value: Instrument)

    @objc(removeInstrumentsObject:)
    @NSManaged public func removeFromInstruments(_ value: Instrument)

    @objc(addInstruments:)
    @NSManaged public func addToInstruments(_ values: NSSet)

    @objc(removeInstruments:)
    @NSManaged public func removeFromInstruments(_ values: NSSet)

}

// MARK: Generated accessors for groups
extension Piece {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}

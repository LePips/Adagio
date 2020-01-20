//
//  Instrument+CoreDataProperties.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData


extension Instrument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instrument> {
        return NSFetchRequest<Instrument>(entityName: "Instrument")
    }

    @NSManaged public var title: String
    @NSManaged public var pieces: NSSet?

}

// MARK: Generated accessors for pieces
extension Instrument {

    @objc(addPiecesObject:)
    @NSManaged public func addToPieces(_ value: Piece)

    @objc(removePiecesObject:)
    @NSManaged public func removeFromPieces(_ value: Piece)

    @objc(addPieces:)
    @NSManaged public func addToPieces(_ values: NSSet)

    @objc(removePieces:)
    @NSManaged public func removeFromPieces(_ values: NSSet)

}

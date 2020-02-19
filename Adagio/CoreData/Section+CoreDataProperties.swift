//
//  Section+CoreDataProperties.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
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
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

//
//  Recording+CoreDataProperties.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData


extension Recording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recording> {
        return NSFetchRequest<Recording>(entityName: "Recording")
    }

    @NSManaged public var title: String
    @NSManaged public var note: String?
    @NSManaged public var url: URL
    @NSManaged public var section: Section?
    @NSManaged public var duration: Double

}

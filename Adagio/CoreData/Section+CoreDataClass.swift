//
//  Section+CoreDataClass.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Section)
public class Section: NSManagedObject {

//    enum CodingKeys: String, CodingKey {
//        case title
//        case note
//        case warmUp
//        case piece
//        case practice
//        case startDate
//        case endDate
//        case recordings
//        case images
//    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.title, forKey: .title)
//        try container.encode(self.note, forKey: .note)
//        try container.encode(self.warmUp, forKey: .warmUp)
//        try container.encode(self.piece, forKey: .piece)
//        try container.encode(self.practice, forKey: .practice)
//        try container.encode(self.startDate, forKey: .startDate)
//        try container.encode(self.endDate, forKey: .endDate)
//        try container.encode(self.recordings.array as! [Recording], forKey: .recordings)
//        try container.encode(self.images, forKey: .images)
//    }
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.title = try container.decode(for: .title)
//        self.note = try container.decode(for: .note)
//        self.warmUp = try container.decode(for: .warmUp)
//        self.piece = try container.decode(for: .piece)
//        self.practice = try container.decode(for: .practice)
//        self.startDate = try container.decode(for: .startDate)
//        self.endDate = try container.decode(for: .endDate)
//        let recordings
//        self.recordings = try container.decode(for: .recordings)
//        self.image = try container.decode(for: .images)
//    }
}

//
//  Recording+CoreDataClass.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/20/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Recording)
public class Recording: NSManagedObject {

//    enum CodingKeys: String, CodingKey {
//        case title
//        case note
//        case url
//        case section
//        case duration
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.title, forKey: .title)
//        try container.encode(self.note, forKey: .note)
//        try container.encode(self.url, forKey: .url)
//        try container.encode(self.section, forKey: .section)
//        try container.encode(self.duration, forKey: .duration)
//    }
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.title = try container.decode(for: .title)
//        self.note = try? container.decode(for: .note)
//        self.url = try container.decode(for: .url)
//        self.section = try container.decode(for: .section)
//        self.duration = try container.decode(for: .duration)
//    }
}

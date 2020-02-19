//
//  Image.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

@objc public class Image: NSObject, NSCoding {

    private(set) var image: UIImage
    private(set) var title: String
    private(set) var note: String?
    
    init(_ image: UIImage, title: String, note: String?) {
        self.image = image
        self.title = title
        self.note = note
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(title, forKey: "title")
        coder.encode(note, forKey: "note")
    }
    
    public required init?(coder: NSCoder) {
        self.image = coder.decodeObject(forKey: "image") as! UIImage
        self.title = coder.decodeObject(forKey: "title") as! String
        self.note = coder.decodeObject(forKey: "note") as! String?
    }
}

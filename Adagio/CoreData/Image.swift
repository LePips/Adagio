//
//  Image.swift
//  Adagio
//
//  Created by Ethan Pippin on 2/16/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit
import SharedPips

@objc public class Image: NSObject, NSCoding, Codable {

    private(set) var image: UIImage
    private(set) var title: String
    private(set) var note: String?
    
    init(_ image: UIImage, title: String, note: String?) {
        self.image = image
        self.title = title
        self.note = note
    }
    
    enum CodingKeys: String, CodingKey {
        case imageData
        case title
        case note
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let imageData = image.pngData() else { throw SimpleError("Could not encode image to data") }
        let imageString = imageData.base64EncodedString()
        try container.encode(imageString, forKey: .imageData)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageString: String = try container.decode(for: .imageData)
        guard let imageData = NSData(base64Encoded: imageString, options: .ignoreUnknownCharacters) else { throw SimpleError("Could not decode image data") }
        guard let image = UIImage(data: imageData as Data) else { throw SimpleError("Could not decode image") }
        self.image = image
        self.title = try container.decode(for: .title)
        self.note = try? container.decode(for: .note)
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

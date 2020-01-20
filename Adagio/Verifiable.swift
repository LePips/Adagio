//
//  Verifiable.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation

protocol Verifiable {
    
    var isValid: Bool { get }
    
    func setInvalid()
    func setValid()
}

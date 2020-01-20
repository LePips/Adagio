//
//  YouViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation

protocol YouViewModelDelegate {
    
    func reloadRows()
}

protocol YouViewModelProtocol: class {
    
    var rows: [YouRow] { get set }
    var delegate: YouViewModelDelegate? { get set }
    
    func reloadRows()
}

class YouViewModel: YouViewModelProtocol {
    
    var rows: [YouRow] = []
    var delegate: YouViewModelDelegate?
    
    func reloadRows() {
        self.rows = YouRow.buildRows()
        delegate?.reloadRows()
    }
}

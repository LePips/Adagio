//
//  HomeViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/17/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate {
    func reloadRows()
}

protocol HomeViewModelProtocol: class {
    
    var rows: [HomeRow] { get set }
    var delegate: HomeViewModelDelegate? { get set }
    
    func reloadRows()
}

class HomeViewModel: HomeViewModelProtocol {
    
    var rows: [HomeRow] = []
    var delegate: HomeViewModelDelegate?
    
    func reloadRows() {
        self.rows = HomeRow.buildRows(practices: [])
        delegate?.reloadRows()
    }
}

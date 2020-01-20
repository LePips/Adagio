//
//  RequestFeatureViewModel.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/19/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import Foundation

protocol RequestFeatureViewModelProtocol: class {
    
    var feedback: String? { get set }
    
    func sendFeedback()
}

class RequestFeatureViewModel: RequestFeatureViewModelProtocol {
    
    var feedback: String?
    
    func sendFeedback() {
        
    }
}

//
//  YouRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum YouRow {
    case subtitle(String)
    case practice(Practice)
}

extension YouRow {
    
    static func buildRows(practices: [Practice]) -> [YouRow] {
        var rows: [YouRow] = [.subtitle("History")]
        
        rows.append(contentsOf: practices.compactMap({ YouRow.practice($0) }))
        
        return rows
    }
    
    static func register(collectionView: UICollectionView) {
        collectionView.register(CollectionSubtitleCell.self, forCellWithReuseIdentifier: CollectionSubtitleCell.identifier)
        collectionView.register(PracticeEntryCell.self, forCellWithReuseIdentifier: PracticeEntryCell.identifier)
    }
    
    func cell(for path: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        switch self {
        case .subtitle(let subtitle):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionSubtitleCell.identifier, for: path) as! CollectionSubtitleCell
            cell.configure(with: subtitle)
            return cell
        case .practice(let practice):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PracticeEntryCell.identifier, for: path) as! PracticeEntryCell
            cell.configure(practice: practice)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .subtitle:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .practice(_):
            return 130
        }
    }
}

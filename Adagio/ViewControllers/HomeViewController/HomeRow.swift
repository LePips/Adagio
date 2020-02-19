//
//  HomeRow.swift
//  Adagio
//
//  Created by Ethan Pippin on 1/18/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import UIKit

enum HomeRow {
    case date
    case practice(Practice)
}

extension HomeRow {
    
    static func buildRows(practices: [Practice]) -> [HomeRow] {
        var rows: [HomeRow] = [.date]
        
        if !practices.isEmpty {
            rows.append(contentsOf: practices.compactMap({ HomeRow.practice($0) }))
        }
        
        return rows
    }
    
    static func register(collectionView: UICollectionView) {
        collectionView.register(CollectionSubtitleCell.self, forCellWithReuseIdentifier: CollectionSubtitleCell.identifier)
        collectionView.register(PracticeEntryCell.self, forCellWithReuseIdentifier: PracticeEntryCell.identifier)
    }
    
    func cell(for path: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        switch self {
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionSubtitleCell.identifier, for: path) as! CollectionSubtitleCell
            let dateFormatter = DateFormatter(format: "EEEE, MMM d")
            cell.configure(with: dateFormatter.string(from: Date()))
            return cell
        case .practice(let practice):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PracticeEntryCell.identifier, for: path) as! PracticeEntryCell
            cell.configure(practice: practice)
            return cell
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .date:
            return "height".height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 18, weight: .medium))
        case .practice(let practice):
            var height: CGFloat = 105
            height += CGFloat((practice.sections ?? []).count) * 30
            return height
        }
    }
}

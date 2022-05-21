//
//  ScrollViewExtension.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit

// MARK: -
extension UICollectionView {
    func reladCurrentView() {
        UIView.performWithoutAnimation {
            reloadItems(at: currentIndexPath())
        }
    }
    
    func currentIndexPath() -> [IndexPath] {
        var aryIndex: [IndexPath]  = []
        
        for cell in visibleCells {
            if let index = indexPath(for: cell) {
                aryIndex.append(index)
            }
        }
        
        return aryIndex
    }
}




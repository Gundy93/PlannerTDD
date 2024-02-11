//
//  UICollectionViewCompositionalLayoutConfiguration.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

extension UICollectionViewCompositionalLayoutConfiguration {
    
    convenience init(
        scrollDirection: UICollectionView.ScrollDirection = .vertical
    ) {
        self.init()
        self.scrollDirection = scrollDirection
    }
}

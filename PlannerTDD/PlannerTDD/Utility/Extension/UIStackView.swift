//
//  UIStackView.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

extension UIStackView {
    
    convenience init(
        arrangedSubviews: [UIView] = [],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        translatesAutoresizingMaskIntoConstraints: Bool = true
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
    }
}

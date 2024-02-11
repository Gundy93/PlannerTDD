//
//  RoundedLabel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

final class RoundedLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += 16
        contentSize.height += 4
        layer.cornerRadius = contentSize.height/2

        return contentSize
    }
    
    convenience init(
        circleColor: UIColor,
        textColor: UIColor
    ) {
        self.init(
            textColor: textColor,
            textAlignment: .center
        )
        backgroundColor = circleColor
        clipsToBounds = true
    }
}

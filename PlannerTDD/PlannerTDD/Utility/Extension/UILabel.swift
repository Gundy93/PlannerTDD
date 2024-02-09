//
//  UILabel.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

extension UILabel {
    
    convenience init(
        font: UIFont = .systemFont(ofSize: 17),
        textColor: UIColor = .label,
        textAlignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1
    ) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

//
//  UITextField.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

extension UITextField {
    
    convenience init(placeholder: String? = nil) {
        self.init()
        self.placeholder = placeholder
    }
}

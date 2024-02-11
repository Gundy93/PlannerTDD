//
//  UITextView.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

extension UITextView {
    
    convenience init(keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none) {
        self.init()
        self.keyboardDismissMode = keyboardDismissMode
    }
}

//
//  UIView+Ext.swift
//  openAIApp
//
//  Created by Eugene Ned on 15.02.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}

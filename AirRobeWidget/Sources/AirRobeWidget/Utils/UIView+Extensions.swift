//
//  UIView+AddShadow.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    func addShadow(color: CGColor? = nil) {
        if let color = color {
            layer.shadowColor = color
        } else {
            layer.shadowColor = UIColor.label.cgColor
        }
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
    }

    func addBorder(color: CGColor? = nil, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil) {
        if let color = color {
            layer.borderColor = color
        } else {
            layer.borderColor = UIColor.label.cgColor
        }
        if let borderWidth = borderWidth {
            layer.borderWidth = borderWidth
        } else {
            layer.borderWidth = 1
        }
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
        } else {
            layer.cornerRadius = 10
        }
    }
}
#endif

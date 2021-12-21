//
//  UIView+AddShadow.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }

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

    func addToSuperView(superView: UIView?) {
        guard let superView = superView else {
            return
        }

        superView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0),
        ])
    }
}
#endif

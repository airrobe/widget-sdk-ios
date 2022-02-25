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

    func addToSuperView(superView: UIView?, alreadyAddedToTable: Bool) -> Bool {
        guard let superView = superView else {
            return false
        }

        superView.addSubview(self)
        frame = superView.bounds
        if let tableView = tableView {
            if !alreadyAddedToTable {
                tableView.beginUpdates()
            }
        } else {
            translatesAutoresizingMaskIntoConstraints = true
        }
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        /// This code smells, but for now, UI's going to break if we don't give an itty-bitty delay.
        /// There's probably a better way to handle this. so in TODO list.
        if !alreadyAddedToTable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView?.endUpdates()
            }
        }
        return true
    }
}
#endif

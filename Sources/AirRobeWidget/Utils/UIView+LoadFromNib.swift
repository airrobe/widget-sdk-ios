//
//  UIView+LoadFromNib.swift
//  
//
//  Created by King on 11/22/21.
//

#if canImport(UIKit)
import UIKit

// MARK: Protocol Definition

/// Make your UIView subclasses conform to this protocol when:
///  * they *are* NIB-based, and
///  * this class is used as the XIB's root view
///
/// to be able to instantiate them from the NIB in a type-safe manner
protocol NibLoadable: AnyObject {
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
}

// MARK: Default implementation

extension NibLoadable {
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: .module)
    }
}

// MARK: Support for instantiation from NIB

extension NibLoadable where Self: UIView {
    /**
    Returns a `UIView` object instantiated from nib

    - returns: A `NibLoadable`, `UIView` instance
    */
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}
#endif

//
//  AirRobeMultiOptIn.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeMultiOptIn: UIView {
    lazy var optInView: AirRobeOptInView = AirRobeOptInView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// initalizing AirRobeMultiOptIn
    /// - Parameters:
    ///   - items: A string array value that contains category of items that are in the shopping cart
    public func initialize(
        items: [String]
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        optInView.viewModel.items = items
        optInView.viewType = .multiOptIn
        optInView.superView = self

        optInView.viewModel.initializeMultiOptInWidget()
    }

    /// When the cart is updated, we are supposed to call this function
    public func updateCategories(
        items: [String]
    ) {
        optInView.viewModel.items = items
    }
}
#endif

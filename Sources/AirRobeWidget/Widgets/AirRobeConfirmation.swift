//
//  AirRobeConfirmation.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeConfirmation: UIView {
    private lazy var orderConfirmationView: OrderConfirmationView = OrderConfirmationView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// initalizing AirRobeConfirmationView
    /// - Parameters:
    ///   - orderId: string value of order Id generated from purchase
    ///   - email: email address that used for the purchase
    public func initialize(
        orderId: String,
        email: String
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        orderConfirmationView.viewModel.orderId = orderId
        orderConfirmationView.viewModel.email = email
        orderConfirmationView.superView = self

        orderConfirmationView.viewModel.initializeConfirmationWidget()
    }
}
#endif

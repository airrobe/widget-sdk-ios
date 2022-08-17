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
    /// Border color of the widget - Default value is #DFDFDF
    @IBInspectable open var borderColor: UIColor = .AirRobeDefaultBorderColor {
        didSet {
            orderConfirmationView.layer.borderColor = borderColor.cgColor
        }
    }

    /// Text color of the widget - Default value is #232323
    @IBInspectable open var textColor: UIColor = .AirRobeDefaultTextColor {
        didSet {
            orderConfirmationView.titleLabel.textColor = textColor
            orderConfirmationView.descriptionLabel.textColor = textColor
        }
    }

    /// AirRobe Confirmation Widget activate button border color - Default value is #232323
    @IBInspectable open var buttonBorderColor: UIColor = .AirRobeDefaultButtonBorderColor {
        didSet {
            orderConfirmationView.activateContainerView.layer.borderColor = buttonBorderColor.cgColor
        }
    }

    /// AirRobe Confirmation Widget activate button text color - Default value is #232323
    @IBInspectable open var buttonTextColor: UIColor = .AirRobeDefaultButtonTextColor {
        didSet {
            orderConfirmationView.activateLoading.color = buttonTextColor
            orderConfirmationView.activateLabel.textColor = buttonTextColor
        }
    }

    lazy var orderConfirmationView: AirRobeOrderConfirmationView = AirRobeOrderConfirmationView.loadFromNib()

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
    ///   - fraudRisk: fraud status for the confirmation widget
    public func initialize(
        orderId: String,
        email: String,
        orderSubTotalCents: Int? = nil
        currency: String = "AUD"
        fraudRisk: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        orderConfirmationView.viewModel.orderId = orderId
        orderConfirmationView.viewModel.email = email
        orderConfirmationView.viewModel.orderSubTotalCents = orderSubTotalCents
        orderConfirmationView.viewModel.currency = currency
        orderConfirmationView.viewModel.fraudRisk = fraudRisk
        orderConfirmationView.superView = self

        orderConfirmationView.viewModel.initializeConfirmationWidget()

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        buttonBorderColor = AirRobeButtonBorderColor
        buttonTextColor = AirRobeButtonTextColor
    }
}
#endif

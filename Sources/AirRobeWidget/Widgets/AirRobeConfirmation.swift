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
    @IBInspectable open var borderColor: UIColor = .AirRobeColors.Default.BorderColor {
        didSet {
            orderConfirmationView.layer.borderColor = borderColor.cgColor
        }
    }

    /// Text color of the widget - Default value is #232323
    @IBInspectable open var textColor: UIColor = .AirRobeColors.Default.TextColor {
        didSet {
            orderConfirmationView.titleLabel.textColor = textColor
            orderConfirmationView.descriptionLabel.textColor = textColor
        }
    }

    /// AirRobe Confirmation Widget activate button border color - Default value is #232323
    @IBInspectable open var buttonBorderColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBorderColor {
        didSet {
            orderConfirmationView.activateContainerView.layer.borderColor = buttonBorderColor.cgColor
        }
    }

    /// AirRobe Confirmation Widget activate button background color - Default value is #FFFFFF
    @IBInspectable open var buttonBackgroundColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBackgroudColor {
        didSet {
            orderConfirmationView.activateContainerView.backgroundColor = buttonBackgroundColor
        }
    }

    /// AirRobe Confirmation Widget activate button text color - Default value is #232323
    @IBInspectable open var buttonTextColor: UIColor = .AirRobeColors.Default.ConfirmationButtonTextColor {
        didSet {
            orderConfirmationView.activateLoading.color = buttonTextColor
            orderConfirmationView.activateLabel.textColor = buttonTextColor
        }
    }

    lazy var orderConfirmationView: DefaultOrderConfirmationView = DefaultOrderConfirmationView.loadFromNib()

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
    ///   - orderSubtotalCents: Sum of line item prices including tax, less discounts, excluding any shipping costs.
    ///   - currency: the ISO 4217 currency code for the order subtotal, defaulting to "AUD" if omitted.
    ///   - fraudRisk: fraud status for the confirmation widget
    public func initialize(
        orderId: String,
        email: String,
        orderSubtotalCents: Int? = nil,
        currency: String = "AUD",
        fraudRisk: Bool = false
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        orderConfirmationView.viewModel.orderId = orderId
        orderConfirmationView.viewModel.email = email
        orderConfirmationView.viewModel.orderSubtotalCents = orderSubtotalCents
        orderConfirmationView.viewModel.currency = currency
        orderConfirmationView.viewModel.fraudRisk = fraudRisk
        orderConfirmationView.superView = self

        orderConfirmationView.viewModel.initializeConfirmationWidget()

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        buttonBorderColor = AirRobeButtonBorderColor
        buttonBackgroundColor = AirRobeButtonBackgroundColor
        buttonTextColor = AirRobeButtonTextColor
    }
}
#endif

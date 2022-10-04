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
    /// Border color of the widget - Default value is #DFDFDF or #000000
    @IBInspectable open var borderColor: UIColor = .AirRobeColors.Default.BorderColor {
        didSet {
            if let orderConfirmationView = orderConfirmationViewDefault {
                orderConfirmationView.layer.borderColor = borderColor.cgColor
            }
            if let orderConfirmationView = orderConfirmationViewEnhanced {
                orderConfirmationView.layer.borderColor = borderColor.cgColor
            }
        }
    }

    /// Text color of the widget - Default value is #232323 or #222222
    @IBInspectable open var textColor: UIColor = .AirRobeColors.Default.TextColor {
        didSet {
            if let orderConfirmationView = orderConfirmationViewDefault {
                orderConfirmationView.titleLabel.textColor = textColor
                orderConfirmationView.descriptionLabel.textColor = textColor
            }
            if let orderConfirmationView = orderConfirmationViewEnhanced {
                orderConfirmationView.titleLabel.textColor = textColor
                orderConfirmationView.descriptionLabel.textColor = textColor
            }
        }
    }

    /// AirRobe Confirmation Widget activate button border color - Default value is #232323 or #FFFFFF
    @IBInspectable open var buttonBorderColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBorderColor {
        didSet {
            if let orderConfirmationView = orderConfirmationViewDefault {
                orderConfirmationView.activateContainerView.layer.borderColor = buttonBorderColor.cgColor
            }
            if let orderConfirmationView = orderConfirmationViewEnhanced {
                orderConfirmationView.activateContainerView.layer.borderColor = buttonBorderColor.cgColor
            }
        }
    }

    /// AirRobe Confirmation Widget activate button background color - Default value is #FFFFFF or #111111
    @IBInspectable open var buttonBackgroundColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBackgroudColor {
        didSet {
            if let orderConfirmationView = orderConfirmationViewDefault {
                orderConfirmationView.activateContainerView.backgroundColor = buttonBackgroundColor
            }
            if let orderConfirmationView = orderConfirmationViewEnhanced {
                orderConfirmationView.activateContainerView.backgroundColor = buttonBackgroundColor
            }
        }
    }

    /// AirRobe Confirmation Widget activate button text color - Default value is #232323 or #FFFFFF
    @IBInspectable open var buttonTextColor: UIColor = .AirRobeColors.Default.ConfirmationButtonTextColor {
        didSet {
            if let orderConfirmationView = orderConfirmationViewDefault {
                orderConfirmationView.activateLoading.color = buttonTextColor
                orderConfirmationView.activateLabel.textColor = buttonTextColor
            }
            if let orderConfirmationView = orderConfirmationViewEnhanced {
                orderConfirmationView.activateLoading.color = buttonTextColor
                orderConfirmationView.activateLabel.textColor = buttonTextColor
            }
        }
    }

    var orderConfirmationViewDefault: DefaultOrderConfirmationView?
    var orderConfirmationViewEnhanced: EnhancedOrderConfirmationView?

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
        if let testVariant = AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.getSplitTestVariant() {
            switch testVariant.splitTestVariant {
            case Variants.enhanced.rawValue:
                orderConfirmationViewEnhanced = EnhancedOrderConfirmationView.loadFromNib()
                orderConfirmationViewEnhanced?.viewModel.orderId = orderId
                orderConfirmationViewEnhanced?.viewModel.email = email
                orderConfirmationViewEnhanced?.viewModel.orderSubtotalCents = orderSubtotalCents
                orderConfirmationViewEnhanced?.viewModel.currency = currency
                orderConfirmationViewEnhanced?.viewModel.fraudRisk = fraudRisk
                orderConfirmationViewEnhanced?.superView = self

                orderConfirmationViewEnhanced?.viewModel.initializeConfirmationWidget()
            default:
                orderConfirmationViewDefault = DefaultOrderConfirmationView.loadFromNib()
                orderConfirmationViewDefault?.viewModel.orderId = orderId
                orderConfirmationViewDefault?.viewModel.email = email
                orderConfirmationViewDefault?.viewModel.orderSubtotalCents = orderSubtotalCents
                orderConfirmationViewDefault?.viewModel.currency = currency
                orderConfirmationViewDefault?.viewModel.fraudRisk = fraudRisk
                orderConfirmationViewDefault?.superView = self

                orderConfirmationViewDefault?.viewModel.initializeConfirmationWidget()
            }
        }

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        buttonBorderColor = AirRobeButtonBorderColor
        buttonBackgroundColor = AirRobeButtonBackgroundColor
        buttonTextColor = AirRobeButtonTextColor
    }
}
#endif

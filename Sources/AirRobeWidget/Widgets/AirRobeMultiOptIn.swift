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
    /// Border color of the widget - Default value is #DFDFDF
    @IBInspectable open var borderColor: UIColor = .AirRobeColors.Default.BorderColor {
        didSet {
            optInView.mainContainerView.layer.borderColor = borderColor.cgColor
        }
    }

    /// Text color of the widget - Default value is #232323
    @IBInspectable open var textColor: UIColor = .AirRobeColors.Default.TextColor {
        didSet {
            optInView.titleLabel.textColor = textColor
            optInView.descriptionLabel.textColor = textColor
            optInView.detailedDescriptionLabel.textColor = textColor
            optInView.extraInfoLabel.textColor = textColor
            optInView.potentialValueLabel.textColor = textColor
            optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
        }
    }

    /// AirRobe switch ON color - Default value is #42ABC8
    @IBInspectable open var switchOnColor: UIColor = .AirRobeColors.Default.SwitchOnTintColor {
        didSet {
            optInView.addToAirRobeSwitch.onTintColor = switchOnColor
        }
    }

    /// AirRobe switch ON color - Default value is #E2E2E2
    @IBInspectable open var switchOffColor: UIColor = .AirRobeColors.Default.SwitchOffTintColor {
        didSet {
            optInView.addToAirRobeSwitch.tintColor = switchOffColor
            optInView.addToAirRobeSwitch.layer.cornerRadius = optInView.addToAirRobeSwitch.frame.height / 2.0
            optInView.addToAirRobeSwitch.backgroundColor = switchOffColor
            optInView.addToAirRobeSwitch.clipsToBounds = true

        }
    }

    /// AirRobe switch thumb ON color - Default value is #FFFFFF
    @IBInspectable open var switchThumbOnColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOnTintColor {
        didSet {
        }
    }

    /// AirRobe switch thumb OFF color - Default value is #222222
    @IBInspectable open var switchThumbOffColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOffTintColor {
        didSet {
        }
    }

    /// AirRobe OptIn Widget drop down arrow icon color - Default value is #42ABC8
    @IBInspectable open var arrowColor: UIColor = .AirRobeColors.Default.ArrowColor {
        didSet {
            optInView.arrowImageView.tintColor = arrowColor
        }
    }

    /// Legal copy text color of the widget - Default value is #696969
    @IBInspectable open var linkTextColor: UIColor = .AirRobeColors.Default.LinkTextColor {
        didSet {
            optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
        }
    }

    lazy var optInView: DefaultOptInView = DefaultOptInView.loadFromNib()

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

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        switchOnColor = AirRobeSwitchOnTintColor
        switchOffColor = AirRobeSwitchOffTintColor
        arrowColor = AirRobeArrowColor
        linkTextColor = AirRobeLinkTextColor
    }

    /// When the cart is updated, we are supposed to call this function
    public func updateCategories(
        items: [String]
    ) {
        optInView.viewModel.items = items
    }
}
#endif

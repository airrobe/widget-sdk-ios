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
    /// Border color of the widget - Default value is #DFDFDF or #000000
    @IBInspectable open var borderColor: UIColor = .AirRobeColors.Default.BorderColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.mainContainerView.layer.borderColor = borderColor.cgColor
            }
            if let optInView = optInViewEnhanced {
                optInView.mainContainerView.layer.borderColor = borderColor.cgColor
            }
        }
    }

    /// Text color of the widget - Default value is #232323 or #222222
    @IBInspectable open var textColor: UIColor = .AirRobeColors.Default.TextColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.titleLabel.textColor = textColor
                optInView.descriptionLabel.textColor = textColor
                optInView.detailedDescriptionLabel.textColor = textColor
                optInView.extraInfoLabel.textColor = textColor
                optInView.potentialValueLabel.textColor = textColor
                optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
                optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            }
            if let optInView = optInViewEnhanced {
                optInView.titleLabel.textColor = textColor
                optInView.descriptionLabel.textColor = textColor
                optInView.detailedDescriptionLabel.textColor = textColor
                optInView.extraInfoLabel.textColor = textColor
                optInView.potentialValueLabel.textColor = textColor
                optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
                optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            }
        }
    }

    /// AirRobe switch ON color - Default value is #42ABC8 or #222222
    @IBInspectable open var switchOnColor: UIColor = .AirRobeColors.Default.SwitchOnTintColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.addToAirRobeSwitch.onTintColor = switchOnColor
            }
            if let optInView = optInViewEnhanced {
                optInView.addToAirRobeSwitch.onTintColor = switchOnColor
            }
        }
    }

    /// AirRobe switch ON color - Default value is #E2E2E2 or #FFFFFF
    @IBInspectable open var switchOffColor: UIColor = .AirRobeColors.Default.SwitchOffTintColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.addToAirRobeSwitch.tintColor = switchOffColor
                optInView.addToAirRobeSwitch.layer.cornerRadius = optInView.addToAirRobeSwitch.frame.height / 2.0
                optInView.addToAirRobeSwitch.backgroundColor = switchOffColor
                optInView.addToAirRobeSwitch.clipsToBounds = true
            }
            if let optInView = optInViewEnhanced {
                optInView.addToAirRobeSwitch.offTintColor = switchOffColor
            }
        }
    }

    /// AirRobe switch thumb ON color - Default value is #FFFFFF
    @IBInspectable open var switchThumbOnColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOnTintColor {
        didSet {
            if let optInView = optInViewEnhanced {
                optInView.addToAirRobeSwitch.thumbOnTintColor = switchThumbOnColor
            }
        }
    }

    /// AirRobe switch thumb OFF color - Default value is #222222
    @IBInspectable open var switchThumbOffColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOffTintColor {
        didSet {
            if let optInView = optInViewEnhanced {
                optInView.addToAirRobeSwitch.thumbOffTintColor = switchThumbOffColor
            }
        }
    }

    /// AirRobe OptIn Widget drop down arrow icon color - Default value is #42ABC8 or #222222
    @IBInspectable open var arrowColor: UIColor = .AirRobeColors.Default.ArrowColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.arrowImageView.tintColor = arrowColor
            }
            if let optInView = optInViewEnhanced {
                optInView.arrowImageView.tintColor = arrowColor
            }
        }
    }

    /// Legal copy text color of the widget - Default value is #696969 or #222222
    @IBInspectable open var linkTextColor: UIColor = .AirRobeColors.Default.LinkTextColor {
        didSet {
            if let optInView = optInViewDefault {
                optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
                optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            }
            if let optInView = optInViewEnhanced {
                optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
                optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            }
        }
    }

    var optInViewDefault: DefaultOptInView?
    var optInViewEnhanced: EnhancedOptInView?

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
        if let testVariant = AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.getSplitTestVariant() {
            switch testVariant.splitTestVariant {
            case Variants.enhanced.rawValue:
                optInViewEnhanced = EnhancedOptInView.loadFromNib()
                optInViewEnhanced?.viewModel.items = items
                optInViewEnhanced?.viewType = .multiOptIn
                optInViewEnhanced?.superView = self

                optInViewEnhanced?.viewModel.initializeMultiOptInWidget()
            default:
                optInViewDefault = DefaultOptInView.loadFromNib()
                optInViewDefault?.viewModel.items = items
                optInViewDefault?.viewType = .multiOptIn
                optInViewDefault?.superView = self

                optInViewDefault?.viewModel.initializeMultiOptInWidget()
            }
        }

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        switchOnColor = AirRobeSwitchOnTintColor
        switchOffColor = AirRobeSwitchOffTintColor
        switchThumbOnColor = AirRobeSwitchThumbOnTintColor
        switchThumbOffColor = AirRobeSwitchThumbOffTintColor
        arrowColor = AirRobeArrowColor
        linkTextColor = AirRobeLinkTextColor
    }

    /// When the cart is updated, we are supposed to call this function
    public func updateCategories(
        items: [String]
    ) {
        if let optInView = optInViewDefault {
            optInView.viewModel.items = items
        }
        if let optInView = optInViewEnhanced {
            optInView.viewModel.items = items
        }
    }
}
#endif

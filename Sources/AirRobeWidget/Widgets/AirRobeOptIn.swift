//
//  AirRobeOptIn.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeOptIn: UIView {
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

    /// initalizing AirRobeOptIn
    /// - Parameters:
    ///   - brand: brand of the shopping item, optional value and can be dismissed
    ///   - material: material of the shopping item, optional value and can be dismissed
    ///   - category: category of the shopping item
    ///   - department: department of the shopping item
    ///   - priceCents: price of the shopping item
    ///   - originalFullPriceCents: original full price of the shopping item, optional value and can be dismissed
    ///   - rrpCents: recommended retail price of the shopping item, optional value and can be dismissed
    ///   - currency: currency in 3 lettered characters, optional value and default value is "AUD"
    ///   - locale: locale, optional value and default value is "en-AU"
    public func initialize(
        brand: String? = nil,
        material: String? = nil,
        category: String,
        department: String? = nil,
        priceCents: Double,
        originalFullPriceCents: Double? = nil,
        rrpCents: Double? = nil,
        currency: String = "AUD",
        locale: String = "en-AU"
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        if let testVariant = AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.getSplitTestVariant() {
            switch testVariant.splitTestVariant {
            case Variants.enhanced.rawValue:
                optInViewEnhanced = EnhancedOptInView.loadFromNib()
                optInViewEnhanced?.viewModel.brand = brand
                optInViewEnhanced?.viewModel.material = material
                optInViewEnhanced?.viewModel.category = category
                optInViewEnhanced?.viewModel.department = department
                optInViewEnhanced?.viewModel.priceCents = priceCents
                optInViewEnhanced?.viewModel.originalFullPriceCents = originalFullPriceCents
                optInViewEnhanced?.viewModel.rrpCents = rrpCents
                optInViewEnhanced?.viewModel.currency = currency
                optInViewEnhanced?.viewModel.locale = locale
                optInViewEnhanced?.viewType = .optIn
                optInViewEnhanced?.superView = self

                optInViewEnhanced?.viewModel.initializeOptInWidget()
            default:
                optInViewDefault = DefaultOptInView.loadFromNib()
                optInViewDefault?.viewModel.brand = brand
                optInViewDefault?.viewModel.material = material
                optInViewDefault?.viewModel.category = category
                optInViewDefault?.viewModel.department = department
                optInViewDefault?.viewModel.priceCents = priceCents
                optInViewDefault?.viewModel.originalFullPriceCents = originalFullPriceCents
                optInViewDefault?.viewModel.rrpCents = rrpCents
                optInViewDefault?.viewModel.currency = currency
                optInViewDefault?.viewModel.locale = locale
                optInViewDefault?.viewType = .optIn
                optInViewDefault?.superView = self

                optInViewDefault?.viewModel.initializeOptInWidget()
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
}
#endif

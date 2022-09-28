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
            optInView.addToAirRobeSwitch.offTintColor = switchOffColor
        }
    }

    /// AirRobe switch thumb ON color - Default value is #FFFFFF
    @IBInspectable open var switchThumbOnColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOnTintColor {
        didSet {
            optInView.addToAirRobeSwitch.thumbOnTintColor = switchThumbOnColor
        }
    }

    /// AirRobe switch thumb OFF color - Default value is #222222
    @IBInspectable open var switchThumbOffColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOffTintColor {
        didSet {
            optInView.addToAirRobeSwitch.thumbOffTintColor = switchThumbOffColor
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

    private var subscribers: [AnyCancellable] = []
    lazy var optInView: EnhancedOptInView = EnhancedOptInView.loadFromNib()

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
        optInView.viewModel.brand = brand
        optInView.viewModel.material = material
        optInView.viewModel.category = category
        optInView.viewModel.department = department
        optInView.viewModel.priceCents = priceCents
        optInView.viewModel.originalFullPriceCents = originalFullPriceCents
        optInView.viewModel.rrpCents = rrpCents
        optInView.viewModel.currency = currency
        optInView.viewModel.locale = locale
        optInView.viewType = .optIn
        optInView.superView = self

        optInView.viewModel.initializeOptInWidget()

        // Default Colors for the widget
        borderColor = AirRobeBorderColor
        textColor = AirRobeTextColor
        switchOnColor = AirRobeSwitchOnTintColor
        switchOffColor = AirRobeSwitchOffTintColor
        arrowColor = AirRobeArrowColor
        linkTextColor = AirRobeLinkTextColor
    }
}
#endif

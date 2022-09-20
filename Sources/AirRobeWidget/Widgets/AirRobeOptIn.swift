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
    @IBInspectable open var borderColor: UIColor = .AirRobeDefaultBorderColor {
        didSet {
            optInView.mainContainerView.layer.borderColor = borderColor.cgColor
        }
    }

    /// Text color of the widget - Default value is #232323
    @IBInspectable open var textColor: UIColor = .AirRobeDefaultTextColor {
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
    @IBInspectable open var switchColor: UIColor = .AirRobeDefaultSwitchColor {
        didSet {
            optInView.addToAirRobeSwitch.onTintColor = switchColor
            optInView.addToAirRobeSwitch.tintColor = switchColor
        }
    }

    /// AirRobe OptIn Widget drop down arrow icon color - Default value is #42ABC8
    @IBInspectable open var arrowColor: UIColor = .AirRobeDefaultArrowColor {
        didSet {
            optInView.arrowImageView.tintColor = arrowColor
        }
    }

    /// Legal copy text color of the widget - Default value is #696969
    @IBInspectable open var linkTextColor: UIColor = .AirRobeDefaultLinkTextColor {
        didSet {
            optInView.extraInfoLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
            optInView.detailedDescriptionLabel.hyperlinkAttributes = [.foregroundColor: linkTextColor]
        }
    }

    private var subscribers: [AnyCancellable] = []
    lazy var optInView: AirRobeOptInView2 = AirRobeOptInView2.loadFromNib()

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
        switchColor = AirRobeSwitchColor
        arrowColor = AirRobeArrowColor
        linkTextColor = AirRobeLinkTextColor
    }
}
#endif

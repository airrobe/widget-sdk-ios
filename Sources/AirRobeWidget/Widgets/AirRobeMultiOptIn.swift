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
        switchColor = AirRobeSwitchColor
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

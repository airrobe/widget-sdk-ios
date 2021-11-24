//
//  OnShopView.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit

// AirRobe view which will be shown on Shopping page.
final class OnShopView: UIView, NibLoadable {
    @IBOutlet weak var widgetStackView: UIStackView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerExpandButton: UIButton!
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potentialValueLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: UILabel!
}
#endif

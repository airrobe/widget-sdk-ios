//
//  WidgetOnShop.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit

// AirRobe widget which will be shown on Shopping page.
final class WidgetOnShop: UIView, NibLoadable {
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potentialValueLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: UILabel!
}
#endif

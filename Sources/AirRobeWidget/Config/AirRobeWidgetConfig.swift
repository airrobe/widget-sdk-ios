//
//  AirRobeWidgetConfig.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation
import UIKit

public struct AirRobeWidgetConfig {

    public enum Mode {
        case production
        case sandbox
    }

    /// AirRobe Widget App ID from https://connector.airrobe.com
    var appId: String = ""

    /// Privacy Policy link for Iconic
    var privacyPolicyURL: String = ""

    /// AirRobe Widget Select Mode whether production or sandbox
    /// default value = .production
    var mode: Mode = .production

    /// set AirRobeWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - privacyPolicyLink: Privacy Policy link for Iconic
    ///   - mode: Selector for production or sandbox mode
    public init(
        appId: String,
        privacyPolicyURL: String,
        mode: Mode = .production
    ) {
        self.appId = appId
        self.privacyPolicyURL = privacyPolicyURL
        self.mode = mode
    }

}

public enum EventName: String {
    case pageView = "pageview"
    case widgetNotRendered = "Widget not rendered"
    case optedIn = "Opted in to AirRobe"
    case optedOut = "Opted out of AirRobe"
    case widgetExpand = "Widget Expand Arrow Click"
    case widgetCollapse = "Widget Collapse Arrow Click"
    case popupClick = "Pop up click"
    case claimLinkClick = "Claim link click"
    case other = "Other"
}

public enum PageName: String {
    case product = "Product"
    case cart = "Cart"
    case thankYou = "Thank You"
    case other = "Other"
}

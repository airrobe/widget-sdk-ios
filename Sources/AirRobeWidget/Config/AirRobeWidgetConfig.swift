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

    /// AirRobe Widget Select Mode whether production or sandbox
    /// default value = .production
    var mode: Mode = .production

    /// set AirRobeWidget AppId
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - mode: Selector for production or sandbox mode
    public init(
        appId: String,
        mode: Mode = .production
    ) {
        self.appId = appId
        self.mode = mode
    }

}

public enum EventName: String {
    case pageView = "airrobe-pageview"
    case widgetRender = "airrobe-widget-render"
    case widgetNotRendered = "airrobe-widget-not-rendered"
    case optIn = "airrobe-widget-opt-in"
    case optOut = "airrobe-widget-opt-out"
    case expand = "airrobe-widget-expand"
    case collapse = "airrobe-widget-collapse"
    case popupOpen = "airrobe-widget-popup-open"
    case popupClose = "airrobe-widget-popup-close"
    case confirmationRender = "airrobe-confirmation-render"
    case confirmationClick = "airrobe-confirmation-click"
}

public enum TelemetryEventName: String {
    case pageView = "pageview"
    case optIn = "Opted in to AirRobe"
    case optOut = "Opted out of AirRobe"
    case expand = "Widget Expand Arrow Click"
    case popupOpen = "Pop up click"
    case confirmationClick = "Claim link click"
}

public enum PageName: String {
    case product = "Product"
    case cart = "Cart"
    case thankYou = "Thank You"
    case other = "Other"
}

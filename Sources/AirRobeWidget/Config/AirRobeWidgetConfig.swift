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
    var privacyPolicyLinkForIconic: String = ""

    /// AirRobe Widget Base Theme Color
    var color: UIColor?

    /// AirRobe Widget Select Mode whether production or sandbox
    /// default value = .production
    var mode: Mode = .production

    /// set AirRobeWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - privacyPolicyLinkForIconic: Privacy Policy link for Iconic
    ///   - color: Primary color for the widgets
    ///   - mode: Selector for production or sandbox mode
    public init(
        appId: String,
        privacyPolicyLinkForIconic: String,
        color: String = "42abc8",
        mode: Mode = .production
    ) {
        self.appId = appId
        self.privacyPolicyLinkForIconic = privacyPolicyLinkForIconic
        self.mode = mode
        UserDefaults.standard.BaseColor = color
    }

}

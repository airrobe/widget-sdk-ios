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

    /// AirRobe Widget Base Theme Color
    var color: UIColor?

    /// AirRobe Widget Select Mode whether production or sandbox
    /// default value = .production
    var mode: Mode = .production

    /// set AirRobeWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - privacyPolicyLink: Privacy Policy link for Iconic
    ///   - color: Primary color for the widgets
    ///   - mode: Selector for production or sandbox mode
    public init(
        appId: String,
        privacyPolicyURL: String,
        color: String = "696969",
        mode: Mode = .production
    ) {
        self.appId = appId
        self.privacyPolicyURL = privacyPolicyURL
        self.mode = mode
        UserDefaults.standard.BaseColor = color
    }

}

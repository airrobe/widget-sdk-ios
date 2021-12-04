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

    /// AirRobe Widget Secret Key from https://connector.airrobe.com
    var secretKey: String = ""

    /// AirRobe Widget Base Theme Color
    var color: UIColor?

    /// AirRobe Widget Select Mode whether production or sandbox
    /// default value = .production
    var mode: Mode = .production

    /// set AirRobWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - secretKey: Secret Key from https://connector.airrobe.com
    public init(
        appId: String,
        secretKey: String,
        color: String = "42abc8",
        mode: Mode = .production
    ) {
        self.appId = appId
        self.secretKey = secretKey
        self.mode = mode
        UserDefaults.standard.BaseColor = color
    }
}

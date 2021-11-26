//
//  AirRobeWidgetConfig.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

public struct AirRobeWidgetConfig {

    public enum Mode {
        case production
        case sandbox
    }

    /// AirRobe Widget App ID from https://connector.airrobe.com
    var appId: String = ""

    /// AirRobe Widget Secret Key from https://connector.airrobe.com
    var secretKey: String = ""

    /// AirRobe Widget Select Mode whether production or sandbox
    /// Initial value = .production
    var mode: Mode = .production

    /// set AirRobWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - secretKey: Secret Key from https://connector.airrobe.com
    public init(
        appId: String,
        secretKey: String,
        mode: Mode = .production
    ) {
        self.appId = appId
        self.secretKey = secretKey
        self.mode = mode
    }
}

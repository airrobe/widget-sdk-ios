//
//  AirRobeWidgetConfig.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

public struct AirRobeWidgetConfig {

    /// AirRobe Widget App ID from https://connector.airrobe.com
    var appId: String = ""

    /// AirRobe Widget Secret Key from https://connector.airrobe.com
    var secretKey: String = ""

    /// set AirRobWidget AppId and SecretKey
    /// - Parameters:
    ///   - appId: App ID from https://connector.airrobe.com
    ///   - secretKey: Secret Key from https://connector.airrobe.com
    public init(
        appId: String,
        secretKey: String
    ) {
        self.appId = appId
        self.secretKey = secretKey
    }
}

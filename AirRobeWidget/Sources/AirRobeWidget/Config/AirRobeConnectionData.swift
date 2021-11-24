//
//  AirRobeConnectionData.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit


/// Storing struct for holding data about the connection to AirRobe service
public struct AirRobeConnectionData {
    /// AirRobe Widget App ID from https://connector.airrobe.com
    public var appId: String

    /// AirRobe Widget Secret Key from https://connector.airrobe.com
    public var secretKey: String

    /// Describes the price of the shopping item. This cannot be set with the initialiser.
    public var price: Float

    /// Describes the Recommended Retail Price of the shopping item. This cannot be set with the initialiser.
    public var rrp: Float

    /// Describes which category the widget belongs to. This cannot be set with the initialiser.
    public var category: String


    /// Create a new AirRobeConnectionData object
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

#endif

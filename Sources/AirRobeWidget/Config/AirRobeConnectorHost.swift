//
//  AirRobeHost.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

enum AirRobeConnectorHost: String {
    case sandbox = "sandbox.connector.airrobe.com"
    case production = "connector.airrobe.com"
}

let priceEngineHost = "price-engine.airrobe.com"
let emailCheckHost = "shop.airrobe.com"

enum AirRobeTelemetryEventHost: String {
    case sandbox = "events.stg.airdemo.link"
    case production = "events.airrobe.com"
}

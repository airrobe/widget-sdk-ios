//
//  AirRobeEventDelegate.swift
//  
//
//  Created by King on 5/24/22.
//

import Foundation

public protocol AirRobeEventDelegate: AnyObject {
    func onEventEmitted(event: AirRobeEventData)
}

public struct AirRobeEventData: Codable {
    let app_id: String
    let anonymous_id: String
    let session_id: String
    let event_name: String
    let source: String
    let version: String
    let split_test_variant: String
    let page_name: String
}

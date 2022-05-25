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

public struct AirRobeEventData {
    public let app_id: String
    public let anonymous_id: String
    public let session_id: String
    public let event_name: EventName
    public let source: String
    public let version: String
    public let split_test_variant: String
    public let page_name: PageName
}

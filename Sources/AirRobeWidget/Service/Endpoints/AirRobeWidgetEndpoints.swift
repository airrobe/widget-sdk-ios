//
//  AirRobeAirRobeWidgetEndpoints.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation
import UIKit

extension AirRobeEndpoint {

    static func getCategoryMapping(operation: AirRobeGraphQLOperation<AppIdInput>) -> AirRobeEndpoint {
        return AirRobeEndpoint(method: .POST, path: "/graphql", getShoppingDataRequestBody: operation, host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue)
    }

    static func emailCheck(operation: AirRobeGraphQLOperation<EmailInput>) -> AirRobeEndpoint {
        return AirRobeEndpoint(method: .POST, path: "/graphql", emailCheckRequestBody: operation, host: emailCheckHost)
    }

    static func priceEngine(price: Double, rrp: Double?, category: String, brand: String?, material: String?) -> AirRobeEndpoint {
        let rrpVal: String? = {
            if let rrp = rrp {
                return String(rrp)
            } else {
                return nil
            }
        }()
        return AirRobeEndpoint(method: .GET, path: "/v1",
                        queryItems: [
                            URLQueryItem(name: "price", value: String(price)),
                            URLQueryItem(name: "rrp", value: rrpVal),
                            URLQueryItem(name: "category", value: category),
                            URLQueryItem(name: "brand", value: brand),
                            URLQueryItem(name: "material", value: material)
                        ]
        )
    }

    static func telemetryEvent(eventName: String, pageName: String) -> AirRobeEndpoint {
        let requestBody: [String: Any] = [
            "app_id": configuration?.appId ?? "",
            "anonymous_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "session_id": sessionId,
            "event_name": eventName,
            "properties": [
                "source": AirRobeWidgetInfo.platform,
                "version": AirRobeWidgetInfo.version,
                "split_test_variant": "default",
                "page_name": pageName
            ]
        ]
        return AirRobeEndpoint(
            method: .POST,
            path: "/telemetry_events",
            requestBody: requestBody,
            host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue
        )
    }

    static func identifyOrder(orderId: String) -> AirRobeEndpoint {
        let requestBody: [String: Any] = [
            "app_id": configuration?.appId ?? "",
            "anonymous_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "session_id": sessionId,
            "external_order_id": orderId,
            "split_test_variant": "default",
            "opted_in": UserDefaults.standard.OrderOptedIn
        ]
        return AirRobeEndpoint(
            method: .POST,
            path: "/internal_webhooks/identify_order",
            requestBody: requestBody,
            host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue
        )
    }
}

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

    static func createOptedOutOrder(operation: AirRobeGraphQLOperation<CreateOptedOutOrderInput>) -> AirRobeEndpoint {
        return AirRobeEndpoint(method: .POST, path: "/graphql", createOptedOutOrderRequestBody: operation, host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue)
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

    static func telemetryEvent(
        eventName: String,
        pageName: String,
        brand: String? = nil,
        material: String? = nil,
        category: String? = nil,
        department: String? = nil,
        itemCount: Int? = nil
    ) -> AirRobeEndpoint {
        var properties: [String: Any] = [
            "source": AirRobeWidgetInfo.platform,
            "version": AirRobeWidgetInfo.version,
            "split_test_variant": UserDefaults.standard.SplitTestVariant?.splitTestVariant ?? "default",
            "page_name": pageName,
        ]
        if let brand = brand {
            properties["brand"] = brand
        }
        if let material = material {
            properties["material"] = material
        }
        if let category = category {
            properties["category"] = category
        }
        if let department = department {
            properties["department"] = department
        }
        if let itemCount = itemCount {
            properties["itemCount"] = itemCount
        }
        let requestBody: [String: Any] = [
            "app_id": configuration?.appId ?? "",
            "anonymous_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "session_id": sessionId,
            "event_name": eventName,
            "properties": properties
        ]
        return AirRobeEndpoint(
            method: .POST,
            path: "/telemetry_events",
            requestBody: requestBody,
            host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue
        )
    }

    static func identifyOrder(orderId: String, orderOptedIn: Bool) -> AirRobeEndpoint {
        let requestBody: [String: Any] = [
            "app_id": configuration?.appId ?? "",
            "anonymous_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "session_id": sessionId,
            "external_order_id": orderId,
            "split_test_variant": UserDefaults.standard.SplitTestVariant?.splitTestVariant ?? "default",
            "opted_in": orderOptedIn
        ]
        return AirRobeEndpoint(
            method: .POST,
            path: "/internal_webhooks/identify_order",
            requestBody: requestBody,
            host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue
        )
    }
}

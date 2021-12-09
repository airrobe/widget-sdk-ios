//
//  AirRobeWidgetEndpoints.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation

extension Endpoint {

    static func getCategoryMapping(operation: GraphQLOperation<AppIdInput>) -> Endpoint {
        return Endpoint(method: .POST, path: "/graphql", categoryMappingRequestBody: operation, host: configuration?.mode == .production ? AirRobeHost.airRobeConnectorProduction.rawValue : AirRobeHost.airRobeConnectorSandbox.rawValue)
    }

    static func emailCheck(operation: GraphQLOperation<EmailInput>) -> Endpoint {
        return Endpoint(method: .POST, path: "/graphql", emailCheckRequestBody: operation, host: emailCheckHost)
    }

    static func priceEngine(price: String, rrp: String, category: String) -> Endpoint {
        return Endpoint(method: .GET, path: "/v1", queryItems: [URLQueryItem(name: "price", value: price),
                                                                URLQueryItem(name: "rrp", value: rrp),
                                                                URLQueryItem(name: "category", value: category)])
    }

}

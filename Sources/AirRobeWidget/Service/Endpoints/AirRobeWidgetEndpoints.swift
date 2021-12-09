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

    static func priceEngine(price: Double, rrp: Double, category: String, brand: String, material: String) -> Endpoint {
        return Endpoint(method: .GET, path: "/v1",
                        queryItems: [
                            URLQueryItem(name: "price", value: String(price)),
                            URLQueryItem(name: "rrp", value: String(rrp)),
                            URLQueryItem(name: "category", value: category),
                            URLQueryItem(name: "brand", value: brand),
                            URLQueryItem(name: "material", value: material)
                        ]
        )
    }

}

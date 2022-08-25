//
//  AirRobeEndpoint.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation
import UIKit

enum RequestMethod: String {
    case POST
    case GET
    case HEAD
    case PUT
    case DELETE
    case PATCH
}

struct AirRobeEndpoint {
    let method: RequestMethod
    let path: String
    var queryItems: [URLQueryItem]
    var requestBody: [String: Any]
    var getShoppingDataRequestBody: AirRobeGraphQLOperation<AppIdInput>?
    var emailCheckRequestBody: AirRobeGraphQLOperation<EmailInput>?
    var createOptedOutOrderRequestBody: AirRobeGraphQLOperation<CreateOptedOutOrderInput>?
    var customHeaders: [String: String]
    var scheme: String
    var host: String
    var timeout: TimeInterval

    init(
        method: RequestMethod = .POST,
        path: String,
        queryItems: [URLQueryItem] = [],
        requestBody: [String: Any] = [:],
        getShoppingDataRequestBody: AirRobeGraphQLOperation<AppIdInput>? = nil,
        emailCheckRequestBody: AirRobeGraphQLOperation<EmailInput>? = nil,
        createOptedOutOrderRequestBody: AirRobeGraphQLOperation<CreateOptedOutOrderInput>? = nil,
        customHeaders: [String: String] = [:],
        scheme: String = "https",
        host: String = priceEngineHost,
        timeout: TimeInterval = 60
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.requestBody = requestBody
        self.getShoppingDataRequestBody = getShoppingDataRequestBody
        self.emailCheckRequestBody = emailCheckRequestBody
        self.createOptedOutOrderRequestBody = createOptedOutOrderRequestBody
        self.customHeaders = customHeaders
        self.scheme = scheme
        self.host = host
        self.timeout = timeout
    }
}

extension AirRobeEndpoint {
    func asURLRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            preconditionFailure("URL could not be created from components: \(components)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        customHeaders.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        if !requestBody.isEmpty, let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) {
            request.httpBody = bodyData
            #if DEBUG
            let str = String(decoding: bodyData, as: UTF8.self)
            print(str)
            #endif
        }
        if let graphQLRequestBody = getShoppingDataRequestBody, let bodyData = try? JSONEncoder().encode(graphQLRequestBody) {
            request.httpBody = bodyData
            #if DEBUG
            let str = String(decoding: bodyData, as: UTF8.self)
            print(str)
            #endif
        }
        if let graphQLRequestBody = emailCheckRequestBody, let bodyData = try? JSONEncoder().encode(graphQLRequestBody) {
            request.httpBody = bodyData
            #if DEBUG
            let str = String(decoding: bodyData, as: UTF8.self)
            print(str)
            #endif
        }
        if let graphQLRequestBody = createOptedOutOrderRequestBody, let bodyData = try? JSONEncoder().encode(graphQLRequestBody) {
            request.httpBody = bodyData
            #if DEBUG
            let str = String(decoding: bodyData, as: UTF8.self)
            print(str)
            #endif
        }

        request.timeoutInterval = timeout

        return request
    }
}

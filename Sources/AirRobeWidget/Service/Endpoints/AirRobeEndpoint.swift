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
    var categoryMappingRequestBody: AirRobeGraphQLOperation<AppIdInput>?
    var emailCheckRequestBody: AirRobeGraphQLOperation<EmailInput>?
    var customHeaders: [String: String]
    var scheme: String
    var host: String
    var timeout: TimeInterval

    init(
        method: RequestMethod = .POST,
        path: String,
        queryItems: [URLQueryItem] = [],
        requestBody: [String: Any] = [:],
        categoryMappingRequestBody: AirRobeGraphQLOperation<AppIdInput>? = nil,
        emailCheckRequestBody: AirRobeGraphQLOperation<EmailInput>? = nil,
        customHeaders: [String: String] = [:],
        scheme: String = "https",
        host: String = priceEngineHost,
        timeout: TimeInterval = 60
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.requestBody = requestBody
        self.categoryMappingRequestBody = categoryMappingRequestBody
        self.emailCheckRequestBody = emailCheckRequestBody
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

        if !requestBody.isEmpty {
            let bodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = bodyData
        }
        if let graphQLRequestBody = categoryMappingRequestBody {
            request.httpBody = try? JSONEncoder().encode(graphQLRequestBody)
            #if DEBUG
            let str = String(decoding: request.httpBody!, as: UTF8.self)
            print(str)
            #endif
        }
        if let graphQLRequestBody = emailCheckRequestBody {
            request.httpBody = try? JSONEncoder().encode(graphQLRequestBody)
            #if DEBUG
            let str = String(decoding: request.httpBody!, as: UTF8.self)
            print(str)
            #endif
        }

        request.timeoutInterval = timeout

        return request
    }
}

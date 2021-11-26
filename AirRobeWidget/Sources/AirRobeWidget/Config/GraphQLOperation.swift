//
//  GraphQLOperation.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

struct GraphQLOperation: Encodable {
    var operationString: String
    var appId: String
    var url: URL

    enum CodingKeys: String, CodingKey {
        case query
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationString, forKey: .query)
    }

    func getURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(appId, forHTTPHeaderField: "x-airrobe-app-id")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(self)
        #if DEBUG
        dump(request)
        #endif

        return request
    }
}

extension GraphQLOperation {
    static func fetchPost(url: URL, appId: String) -> Self {
        GraphQLOperation(operationString: Strings.GetMappingInfoQuery, appId: appId, url: url)
    }
}

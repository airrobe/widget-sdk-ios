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
        request.addValue("Application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "x-airrobe-app-id")
        request.addValue("HdHwWAavwpPpWNyUr0g72xiTlNSkUngwzz275eO91+0=", forHTTPHeaderField: "x-airrobe-hmac-sha256")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(self)

        return request
    }
}

extension GraphQLOperation {
    static func fetchPost(url: URL, appId: String) -> Self {
        GraphQLOperation(operationString: Strings.GetMappingInfoQuery, appId: appId, url: url)
    }
}

//
//  GraphQLOperation.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

struct AppIdInput: Encodable {
    let appId: String
}

struct EmailInput: Encodable {
    let email: String
}

struct GraphQLOperation<Input: Encodable>: Encodable {
    var input: Input
    var operationString: String

    enum CodingKeys: String, CodingKey {
        case variables
        case query
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(input, forKey: .variables)
        try container.encode(operationString, forKey: .query)
    }
}

extension GraphQLOperation where Input == AppIdInput {
    static func fetchPost(with appId: String) -> Self {
        GraphQLOperation(
            input: AppIdInput(appId: appId),
            operationString: Strings.GetMappingInfoQuery
        )
    }
}

extension GraphQLOperation where Input == EmailInput {
    static func fetchPost(with email: String) -> Self {
        GraphQLOperation(
            input: EmailInput(email: email),
            operationString: Strings.CheckEmailQuery
        )
    }
}

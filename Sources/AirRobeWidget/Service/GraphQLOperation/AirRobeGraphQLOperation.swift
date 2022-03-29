//
//  AirRobeGraphQLOperation.swift
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

struct AirRobeGraphQLOperation<Input: Encodable>: Encodable {
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

extension AirRobeGraphQLOperation where Input == AppIdInput {
    static func fetchPost(with appId: String) -> Self {
        AirRobeGraphQLOperation(
            input: AppIdInput(appId: appId),
            operationString: AirRobeStrings.GetShoppingDataQuery
        )
    }
}

extension AirRobeGraphQLOperation where Input == EmailInput {
    static func fetchPost(with email: String) -> Self {
        AirRobeGraphQLOperation(
            input: EmailInput(email: email),
            operationString: AirRobeStrings.CheckEmailQuery
        )
    }
}

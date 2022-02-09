//
//  AirRobeNetworkClient.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation
import Combine

struct NetworkClientErrorResponseModel: Codable {
    let message: String
    let status: Int
}

enum NetworkClientError: Error {
    case message(statusCode: Int, message: String)

    var localizedDescription: String {
        switch self {
        case .message(_, let message): return message
        }
    }
}

protocol AirRobeNetworkClient {
    var session: URLSession { get }

    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    decoder: JSONDecoder,
                    queue: DispatchQueue,
                    retries: Int) -> AnyPublisher<T, Error> where T: Decodable
}

extension AirRobeNetworkClient {
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    decoder: JSONDecoder = JSONDecoder(),
                    queue: DispatchQueue = .main,
                    retries: Int = 0) -> AnyPublisher<T, Error> where T: Decodable {

        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else {
                    throw NSError(domain: "com.airrobe.networkclient",
                                  code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Missing response"])
                }
                guard 200..<300 ~= response.statusCode else {
                    if let errorModel = try? JSONDecoder().decode(NetworkClientErrorResponseModel.self, from: $0.data) {
                        throw NetworkClientError.message(statusCode: errorModel.status, message: errorModel.message)
                    } else {
                        throw NSError(domain: "com.airrobe.networkclient",
                                      code: response.statusCode,
                                      userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)])
                    }
                }
                return $0.data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
}

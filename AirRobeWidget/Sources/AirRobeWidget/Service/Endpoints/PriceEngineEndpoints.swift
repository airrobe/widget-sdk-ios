//
//  File.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation

extension Endpoint {

    static func priceEngine(price: String, rrp: String, category: String) -> Endpoint {
        return Endpoint(method: .GET, path: "/v1", queryItems: [URLQueryItem(name: "price", value: price),
                                                                URLQueryItem(name: "rrp", value: rrp),
                                                                URLQueryItem(name: "category", value: category)])
    }

}

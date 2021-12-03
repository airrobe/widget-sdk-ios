//
//  AirRobePriceEngineApiService.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation
import Combine
import UIKit

final class AirRobePriceEngineApiService: NetworkClient {
    let session: URLSession
    let additionalRequestBodyParams: [String: String]

    /// AirRobWidget PriceEngine Api Service Initialization
    /// - Parameters:
    ///   - configuration: URLSessionConfiguration here - most likely to add the app & system information to the URLRequest header
    ///   - additionalRequestBodyParams: In case we need to have something like Device ID, App version, Country or etc.
    init(configuration: URLSessionConfiguration? = nil,
         additionalRequestBodyParams: [String: String] = [:]) {

        let sessionConfig = configuration ?? URLSessionConfiguration.default

        let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let systemVersion = UIDevice.current.systemVersion
        let userAgentHeaderValue = "airrobeWidget/\(appVersion) (\(bundleId); build:\(buildNumber); iOS \(systemVersion)) URLSession"
        sessionConfig.httpAdditionalHeaders = ["User-Agent": userAgentHeaderValue]

        self.session = URLSession(configuration: sessionConfig)
        self.additionalRequestBodyParams = additionalRequestBodyParams
    }

    func priceEngine(price: String, rrp: String, category: String) -> AnyPublisher<PriceEngineResponseModel, Error> {
        var endpoint = Endpoint.priceEngine(price: price, rrp: rrp, category: category)
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: PriceEngineResponseModel.self)
    }
}

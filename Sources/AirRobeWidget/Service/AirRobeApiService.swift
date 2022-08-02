//
//  AirRobeApiService.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation
import Combine
import UIKit

final class AirRobeApiService: AirRobeNetworkClient {
    let session: URLSession
    let additionalRequestBodyParams: [String: String]

    /// AirRobWidget Api Service Initialization
    /// - Parameters:
    ///   - configuration: URLSessionConfiguration here - most likely to add the app & system information to the URLRequest header
    ///   - additionalRequestBodyParams: In case we need to have something like Device ID, App version or etc.
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

    func priceEngine(price: Double, rrp: Double? = nil, category: String, brand: String? = nil, material: String? = nil) -> AnyPublisher<AirRobePriceEngineResponseModel, Error> {
        var endpoint = AirRobeEndpoint.priceEngine(price: price, rrp: rrp, category: category, brand: brand, material: material)
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: AirRobePriceEngineResponseModel.self)
    }

    func getShoppingData(operation: AirRobeGraphQLOperation<AppIdInput>) -> AnyPublisher<AirRobeGetShoppingDataModel, Error> {
        var endpoint = AirRobeEndpoint.getCategoryMapping(operation: operation)
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: AirRobeGetShoppingDataModel.self)
    }

    func emailCheck(operation: AirRobeGraphQLOperation<EmailInput>) -> AnyPublisher<AirRobeEmailCheckResponseModel, Error> {
        var endpoint = AirRobeEndpoint.emailCheck(operation: operation)
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: AirRobeEmailCheckResponseModel.self)
    }

    func telemetryEvent(
        eventName: String,
        pageName: String,
        brand: String? = nil,
        material: String? = nil,
        category: String? = nil,
        department: String? = nil
    ) -> AnyPublisher<AirRobeTelemetryEventResponseModel, Error> {
        var endpoint = AirRobeEndpoint.telemetryEvent(
            eventName: eventName,
            pageName: pageName,
            brand: brand,
            material: material,
            category: category,
            department: department
        )
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: AirRobeTelemetryEventResponseModel.self)
    }

    func identifyOrder(orderId: String, orderOptedIn: Bool) -> AnyPublisher<AirRobeIdentifyOrderResponseModel, Error> {
        var endpoint = AirRobeEndpoint.identifyOrder(orderId: orderId, orderOptedIn: orderOptedIn)
        endpoint.requestBody = endpoint.requestBody.merging(additionalRequestBodyParams) { (current, _) in current }
        #if DEBUG
        dump(endpoint.asURLRequest())
        #endif
        return execute(endpoint.asURLRequest(), decodingType: AirRobeIdentifyOrderResponseModel.self)
    }
}

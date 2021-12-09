//
//  AirRobeWidget.swift
//
//
//  Created by King on 11/22/21.
//

import Foundation
import Combine

var configuration: AirRobeWidgetConfig?
private var apiService = AirRobeApiService()
private var cancellable: AnyCancellable?

public func initialize(config: AirRobeWidgetConfig) {
    AirRobeWidget.configuration = config

    cancellable = apiService.getCategoryMapping(operation: GraphQLOperation.fetchPost(with: config.appId))
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                #if DEBUG
                print("Category Mapping Issue: ", error)
                #endif
            case .finished:
                print(completion)
            }
        }, receiveValue: {
            print($0)
            CategoryModelInstance.shared.categoryModel = $0
        })
}

public func clearCache() {
    UserDefaults.standard.OtpInfo = false
}

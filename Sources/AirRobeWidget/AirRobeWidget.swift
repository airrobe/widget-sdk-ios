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

    cancellable = apiService.getCategoryMapping(operation: AirRobeGraphQLOperation.fetchPost(with: config.appId))
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
            AirRobeCategoryModelInstance.shared.categoryModel = $0
        })
}

public func resetOptedIn() {
    UserDefaults.standard.OptedIn = false
}

public func orderOptedIn() -> Bool {
    return UserDefaults.standard.OrderOptedIn
}

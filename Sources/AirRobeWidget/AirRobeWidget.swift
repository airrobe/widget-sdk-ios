//
//  AirRobeWidget.swift
//
//
//  Created by King on 11/22/21.
//

#if canImport(UIKit)
import Foundation
import Combine
import UIKit

var configuration: AirRobeWidgetConfig?
private var apiService = AirRobeApiService()
private var cancellable: AnyCancellable?

public func initialize(config: AirRobeWidgetConfig) {
    AirRobeWidget.configuration = config

    _ = apiService.telemetryEvent(eventName: "Initializing AirRobe Widget", widgetName: "SDK initialization")
    cancellable = apiService.getShoppingData(operation: AirRobeGraphQLOperation.fetchPost(with: config.appId))
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
            AirRobeShoppingDataModelInstance.shared.shoppingDataModel = $0
        })
}

public func checkMultiOptInEligibility(items: [String]) -> Bool {
    guard let shoppingDataModel = AirRobeShoppingDataModelInstance.shared.shoppingDataModel, !items.isEmpty else {
        return false
    }
    return shoppingDataModel.checkCategoryEligible(items: items).eligible
}

public func resetOptedIn() {
    UserDefaults.standard.OptedIn = false
}

public func orderOptedIn() -> Bool {
    return UserDefaults.standard.OrderOptedIn
}

/// Border color of the widget - Default value is #DFDFDF
public var AirRobeBorderColor: UIColor = .AirRobeDefaultBorderColor

/// Text color of the widget - Default value is #232323
public var AirRobeTextColor: UIColor = .AirRobeDefaultTextColor

/// AirRobe switch ON color - Default value is #42ABC8
public var AirRobeSwitchColor: UIColor = .AirRobeDefaultSwitchColor

/// AirRobe OptIn Widget drop down arrow icon color - Default value is #42ABC8
public var AirRobeArrowColor: UIColor = .AirRobeDefaultArrowColor

/// Legal copy text color of the widget - Default value is #696969
public var AirRobeLinkTextColor: UIColor = .AirRobeDefaultLinkTextColor

/// AirRobe Confirmation Widget activate button background color - Default value is #232323
public var AirRobeButtonBorderColor: UIColor = .AirRobeDefaultButtonBorderColor

/// AirRobe Confirmation Widget activate button text color - Default value is #232323
public var AirRobeButtonTextColor: UIColor = .AirRobeDefaultButtonTextColor

/// AirRobe Learn More Widget Separator color - Default value is #DFDFDF
public var AirRobeSeparatorColor: UIColor = .AirRobeDefaultSeparatorColor

#endif

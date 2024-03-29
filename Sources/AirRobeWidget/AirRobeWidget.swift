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
var sessionId = ""
private var apiService = AirRobeApiService()
private var cancellable: AnyCancellable?

public func initialize(config: AirRobeWidgetConfig) {
    AirRobeWidget.configuration = config
    sessionId = Date().millisecondsSince1970
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
            for i in 0..<$0.data.shop.categoryMappings.count {
                AirRobeShoppingDataModelInstance.shared.categoryMapping.categoryMappingsHashMap[$0.data.shop.categoryMappings[i].from] = $0.data.shop.categoryMappings[i]
            }
            updateDefaultColors()
        })
}

public weak var delegate: AirRobeEventDelegate?

public func trackPageView(pageName: String) {
    AirRobeUtils.telemetryEvent(eventName: EventName.pageView.rawValue, pageName: pageName)
}

public func checkMultiOptInEligibility(items: [String]) -> Bool {
    guard !AirRobeShoppingDataModelInstance.shared.categoryMapping.categoryMappingsHashMap.isEmpty, !items.isEmpty else {
        return false
    }
    return AirRobeShoppingDataModelInstance.shared.categoryMapping.checkCategoryEligible(items: items).eligible
}

public func checkConfirmationEligibility(orderId: String, email: String, fraudRisk: Bool) -> Bool {
    if orderId.isEmpty || email.isEmpty {
        return false
    }
    return UserDefaults.standard.OrderOptedIn && !fraudRisk
}

public func resetOrder() {
    UserDefaults.standard.OrderOptedIn = false
}

public func resetOptedIn() {
    UserDefaults.standard.OptedIn = false
}

public func orderOptedIn() -> Bool {
    return UserDefaults.standard.OrderOptedIn
}

/// Border color of the widget - Default value is #DFDFDF or #000000
public var AirRobeBorderColor: UIColor = .AirRobeColors.Default.BorderColor

/// Text color of the widget - Default value is #232323 or #222222
public var AirRobeTextColor: UIColor = .AirRobeColors.Default.TextColor

/// AirRobe switch ON color - Default value is #42ABC8 or #222222
public var AirRobeSwitchOnTintColor: UIColor = .AirRobeColors.Default.SwitchOnTintColor

/// AirRobe switch OFF color - Default value is #E2E2E2 or #FFFFFF
public var AirRobeSwitchOffTintColor: UIColor = .AirRobeColors.Default.SwitchOffTintColor

/// AirRobe switch thumb ON color - Default value is #FFFFFF
/// - It applies to only specific widget variant.
public var AirRobeSwitchThumbOnTintColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOnTintColor

/// AirRobe switch thumb OFF color - Default value is #222222
/// - It applies to only specific widget variant.
public var AirRobeSwitchThumbOffTintColor: UIColor = .AirRobeColors.Enhanced.SwitchThumbOffTintColor

/// AirRobe OptIn Widget drop down arrow icon color - Default value is #42ABC8 or #222222
public var AirRobeArrowColor: UIColor = .AirRobeColors.Default.ArrowColor

/// Legal copy text color of the widget - Default value is #696969 or #222222
public var AirRobeLinkTextColor: UIColor = .AirRobeColors.Default.LinkTextColor

/// AirRobe Confirmation Widget activate button border color - Default value is #232323 or #FFFFFF
public var AirRobeButtonBorderColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBorderColor

/// AirRobe Confirmation Widget activate button text color - Default value is #232323 or #FFFFFF
public var AirRobeButtonTextColor: UIColor = .AirRobeColors.Default.ConfirmationButtonTextColor

/// AirRobe Confirmation Widget activate button background color - Default value is #FFFFFF or #111111
public var AirRobeButtonBackgroundColor: UIColor = .AirRobeColors.Default.ConfirmationButtonBackgroudColor

/// AirRobe Learn More Popup Widget Separator color - Default value is #DFDFDF or #222222
public var AirRobeSeparatorColor: UIColor = .AirRobeColors.Default.SeparatorColor

/// AirRobe Learn More Popup widget switch container background color - Default value is #F1F1F1
/// - It applies to only specific widget variant.
public var AirRobePopupSwitchBackgroundColor: UIColor = .AirRobeColors.Enhanced.PopupSwitchContainerBackgroundColor

#endif

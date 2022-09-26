//
//  AirRobeOptInViewModel.swift
//  
//
//  Created by King on 12/16/21.
//

import Foundation
import Combine

final class AirRobeOptInViewModel {

    /// Describes which brand the shopping item belongs to.
    var brand: String?
    /// Describes which material the shopping item belongs to.
    var material: String?
    /// Describes which category the shopping item belongs to.
    var category: String = ""
    /// Describes which department the shopping item belongs to.
    var department: String?
    /// Describes the price of the shopping item.
    var priceCents: Double = 0.0
    /// Describes the original full price of the shopping item.
    var originalFullPriceCents: Double?
    /// Describes the Recommended Retail Price of the shopping item.
    var rrpCents: Double?
    /// Describes the currency.
    var currency: String?
    /// Describes the current locale of the device.
    var locale: String?

    /// Describes the categorys mapping info in String array for the items in the cart.
    @Published var items: [String] = []

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?
    var alreadyInitialized: Bool = false

    @Published var isAllSet: AirRobeWidgetLoadState = .initializing
    @Published var potentialPrice: String = ""

    func initializeOptInWidget() {
        guard
            let shoppingDataModel = AirRobeShoppingDataModelInstance.shared.shoppingDataModel,
            !AirRobeShoppingDataModelInstance.shared.categoryMapping.categoryMappingsHashMap.isEmpty
        else {
            isAllSet = .noCategoryMappingInfo
            return
        }

        if let testVariant = shoppingDataModel.getSplitTestVariant(), testVariant.disabled {
            isAllSet = .widgetDisabled
            AirRobeUtils.telemetryEvent(
                eventName: TelemetryEventName.pageView.rawValue,
                pageName: PageName.product.rawValue,
                brand: brand,
                material: material,
                category: category,
                department: department
            )
            AirRobeUtils.dispatchEvent(eventName: EventName.pageView.rawValue, pageName: PageName.product.rawValue)
            return
        }

        if !alreadyInitialized {
            AirRobeUtils.telemetryEvent(
                eventName: TelemetryEventName.pageView.rawValue,
                pageName: PageName.product.rawValue,
                brand: brand,
                material: material,
                category: category,
                department: department
            )
            AirRobeUtils.dispatchEvent(eventName: EventName.pageView.rawValue, pageName: PageName.product.rawValue)
            alreadyInitialized = true
        }

        if category.isEmpty {
            isAllSet = .paramIssue
            return
        }
        let eligibility = AirRobeShoppingDataModelInstance.shared.categoryMapping.checkCategoryEligible(items: [category])
        if isAllSet == .eligible {
            if !(eligibility.eligible && !shoppingDataModel.isBelowPriceThreshold(department: department, price: priceCents)) {
                isAllSet = .notEligible
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetNotRendered.rawValue, pageName: PageName.product.rawValue)
            }
        } else {
            isAllSet = (eligibility.eligible && !shoppingDataModel.isBelowPriceThreshold(department: department, price: priceCents)) ? .eligible : .notEligible
            if isAllSet == .eligible {
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetRender.rawValue, pageName: PageName.product.rawValue)
                callPriceEngine(category: eligibility.to)
            } else {
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetNotRendered.rawValue, pageName: PageName.product.rawValue)
            }
        }
    }

    func initializeMultiOptInWidget() {
        guard
            let shoppingDataModel = AirRobeShoppingDataModelInstance.shared.shoppingDataModel,
            !AirRobeShoppingDataModelInstance.shared.categoryMapping.categoryMappingsHashMap.isEmpty
        else {
            isAllSet = .noCategoryMappingInfo
            UserDefaults.standard.OrderOptedIn = false
            return
        }

        if let testVariant = shoppingDataModel.getSplitTestVariant(), testVariant.disabled {
            isAllSet = .widgetDisabled
            AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.pageView.rawValue, pageName: PageName.cart.rawValue)
            AirRobeUtils.dispatchEvent(eventName: EventName.pageView.rawValue, pageName: PageName.cart.rawValue)
            return
        }

        if !alreadyInitialized {
            AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.pageView.rawValue, pageName: PageName.cart.rawValue, itemCount: items.count)
            AirRobeUtils.dispatchEvent(eventName: EventName.pageView.rawValue, pageName: PageName.cart.rawValue)
            alreadyInitialized = true
        }

        if items.isEmpty {
            isAllSet = .paramIssue
            UserDefaults.standard.OrderOptedIn = false
            return
        }
        let eligibility = AirRobeShoppingDataModelInstance.shared.categoryMapping.checkCategoryEligible(items: items)
        if isAllSet == .eligible {
            if !eligibility.eligible {
                isAllSet = .notEligible
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetNotRendered.rawValue, pageName: PageName.cart.rawValue)
                UserDefaults.standard.OrderOptedIn = false
            }
        } else {
            isAllSet = eligibility.eligible ? .eligible : .notEligible
            UserDefaults.standard.OrderOptedIn = eligibility.eligible && UserDefaults.standard.OptedIn ? true : false
            if isAllSet == .eligible {
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetRender.rawValue, pageName: PageName.cart.rawValue)
            } else {
                AirRobeUtils.dispatchEvent(eventName: EventName.widgetNotRendered.rawValue, pageName: PageName.cart.rawValue)
            }
        }
    }

}

private extension AirRobeOptInViewModel {

    func callPriceEngine(category: String) {
        let rrp: Double? = {
            if let rrpCents = rrpCents {
                return rrpCents
            }
            if let originalFullPriceCents = originalFullPriceCents {
                return originalFullPriceCents
            }
            return nil
        }()
        cancellable = apiService.priceEngine(price: priceCents, rrp: rrp, category: category, brand: brand, material: material)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("PriceEngine Api Issue: ", error)
                    #endif
                    self?.potentialPrice = self?.fallbackResalePrice() ?? ""
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let result = $0.result, let resaleValue = result.resaleValue else {
                    self?.potentialPrice = self?.fallbackResalePrice() ?? ""
                    return
                }
                self?.potentialPrice = String(resaleValue)
            })
    }

    func fallbackResalePrice() -> String {
        let resaleValue = round(100 * ((priceCents * 65) / 100)) / 100
        return String(resaleValue)
    }

}

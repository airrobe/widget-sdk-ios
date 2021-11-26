//
//  WidgetOnShopModel.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation
import Combine

class WidgetOnShopModel {

    enum LoadState: String {
        case notInitialized = "Widget Initializing"
        case loaded
        case loadedButInvisible
        case loadedWithMappingInfoIssue = "Please initialize the sdk with your AppID and Secret Key"
        case loadedWithParamIssue = "Please initialize the widget with the valid information"
        case loadedWithPriceEngineIssue = "Not able to get the valid information from Price Engine-v1"
    }

    /// Describes which brand the widget belongs to.
    var brand: String = ""
    /// Describes which material the widget belongs to.
    var material: String = ""
    /// Describes which category the widget belongs to.
    var category: String = ""
    /// Describes the price of the shopping item.
    var priceCents: String = ""
    /// Describes the original full price of the shopping item.
    var originalFullPriceCents: String = ""
    /// Describes the Recommended Retail Price of the shopping item.
    var rrpCents: String = ""
    /// Describes the currency.
    var currency: String = ""
    /// Describes the current locale of the device.
    var locale: String = ""

    @Published var isAllSet: LoadState = .notInitialized
    @Published var potentialPrice: String = ""

    private let categoryMappingInfo = UserDefaults.standard.categoryMappingInfo
    private lazy var priceEngineApiService = AirRobePriceEngineApiService()
    private(set) lazy var widgetBuildModel = WidgetOnShopModel()
    private var cancellable: AnyCancellable?

    func initializeWidget() {
        if category.isEmpty || priceCents.isEmpty || rrpCents.isEmpty {
            isAllSet = .loadedWithParamIssue
            return
        }
        getCategoryFromMappings()
    }
}

private extension WidgetOnShopModel {

    func getCategoryFromMappings() {
        guard let categoryMappingInfo = categoryMappingInfo else {
            isAllSet = .loadedWithMappingInfoIssue
            return
        }
        let categoryMappings = categoryMappingInfo.data.shop.categoryMappings
        guard let mappingIndex = categoryMappings.firstIndex(where: { $0.from == category }) else {
            isAllSet = .loadedButInvisible
            return
        }
        guard let to = categoryMappings[mappingIndex].to, !to.isEmpty, !categoryMappings[mappingIndex].excluded else {
            isAllSet = .loadedButInvisible
            return
        }
        callPriceEngine(category: to)
    }

    func callPriceEngine(category: String) {
        cancellable = priceEngineApiService.priceEngine(price: priceCents, rrp: rrpCents, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("PriceEngine Api Issue: ", error)
                    #endif
                    self.isAllSet = .loadedWithPriceEngineIssue
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                print($0)
                guard let result = $0.result, let resaleValue = result.resaleValue else {
                    self.isAllSet = .loadedWithPriceEngineIssue
                    return
                }
                self.potentialPrice = String(resaleValue)
                self.isAllSet = .loaded
            })
    }

}

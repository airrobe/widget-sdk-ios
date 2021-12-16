//
//  AirRobeOptInModel.swift
//  
//
//  Created by King on 11/25/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeOptInModel {
    /// Describes which brand the widget belongs to.
    var brand: String?
    /// Describes which material the widget belongs to.
    var material: String?
    /// Describes which category the widget belongs to.
    var category: String = ""
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

    @Published var isAllSet: OptInView.LoadState = .initializing
    @Published var potentialPrice: String = ""

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?

    func initializeWidget() {
        guard let categoryModel = CategoryModelInstance.shared.categoryModel else {
            isAllSet = .noCategoryMappingInfo
            return
        }
        if category.isEmpty {
            isAllSet = .paramIssue
            return
        }
        isAllSet = categoryModel.checkCategoryEligible(items: [category]).eligible ? .eligible : .notEligible
        if isAllSet == .eligible {
            callPriceEngine(category: categoryModel.checkCategoryEligible(items: [category]).to)
        }
    }
}

private extension AirRobeOptInModel {

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
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("PriceEngine Api Issue: ", error)
                    #endif
                    self.potentialPrice = self.fallbackResalePrice()
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                guard let result = $0.result, let resaleValue = result.resaleValue else {
                    self.potentialPrice = self.fallbackResalePrice()
                    return
                }
                self.potentialPrice = String(resaleValue)
            })
    }

    func fallbackResalePrice() -> String {
        let resaleValue = round(100 * ((priceCents * 65) / 100)) / 100
        return String(resaleValue)
    }
}
#endif

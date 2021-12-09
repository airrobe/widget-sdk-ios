//
//  AirRobeOtpInModel.swift
//  
//
//  Created by King on 11/25/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeOtpInModel {

    enum LoadState: String {
        case initializing = "Widget Initializing"
        case eligible
        case notEligible
        case paramIssue = "Please initialize the widget with the valid information"
        case priceEngineIssue = "Not able to get the valid information from Price Engine-v1"
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

    @Published var isAllSet: LoadState = .initializing
    @Published var potentialPrice: String = ""

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?

    func initializeWidget(categoryModel: CategoryModel) {
        if category.isEmpty || priceCents.isEmpty || rrpCents.isEmpty {
            isAllSet = .paramIssue
            return
        }
        isAllSet = categoryModel.checkCategoryEligible(items: [category]).eligible ? .eligible : .notEligible
        if isAllSet == .eligible {
            callPriceEngine(category: categoryModel.checkCategoryEligible(items: [category]).to)
        }
    }
}

private extension AirRobeOtpInModel {

    func callPriceEngine(category: String) {
        cancellable = apiService.priceEngine(price: priceCents, rrp: rrpCents, category: category)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("PriceEngine Api Issue: ", error)
                    #endif
                    self.isAllSet = .priceEngineIssue
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                guard let result = $0.result, let resaleValue = result.resaleValue else {
                    self.isAllSet = .priceEngineIssue
                    return
                }
                self.potentialPrice = String(resaleValue)
            })
    }

}
#endif

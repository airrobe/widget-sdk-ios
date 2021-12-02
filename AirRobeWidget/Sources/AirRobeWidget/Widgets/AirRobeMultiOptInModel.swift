//
//  AirRobeMultiOtpInModel.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeMultiOtpInModel {

    enum LoadState: String {
        case notInitialized = "Widget Initializing"
        case loaded
        case loadedButInvisible
        case loadedWithMappingInfoIssue = "Please initialize the sdk with your AppID and Secret Key"
        case loadedWithParamIssue = "Please initialize the widget with the valid information"
    }

    /// The instance of the parent view controller
    var vc: UIViewController = UIViewController()
    /// Describes the categorys mapping info in String array for the items in the cart .
    var items: [String] = []

    @Published var isAllSet: LoadState = .notInitialized

    func initializeWidget() {
        if items.isEmpty {
            isAllSet = .loadedWithParamIssue
            return
        }
        checkCategories()
    }
}

private extension AirRobeMultiOtpInModel {

    func checkCategories() {
        guard let categoryMappingInfo = UserDefaults.standard.categoryMappingInfo else {
            isAllSet = .loadedWithMappingInfoIssue
            return
        }
        let categoryMappings = categoryMappingInfo.data.shop.categoryMappings
        let filteredCategoryMappings = categoryMappings.filter { items.contains($0.from) }
        guard !filteredCategoryMappings.isEmpty else {
            isAllSet = .loadedButInvisible
            return
        }
        let filteredByExcludedAndTo = filteredCategoryMappings.filter {
            guard let to = $0.to else {
                return false
            }
            return !to.isEmpty && !$0.excluded
        }
        guard !filteredByExcludedAndTo.isEmpty else {
            isAllSet = .loadedButInvisible
            return
        }
        isAllSet = .loaded
    }
}
#endif

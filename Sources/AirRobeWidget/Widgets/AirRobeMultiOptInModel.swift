//
//  AirRobeMultiOptInModel.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeMultiOptInModel {
    /// Describes the categorys mapping info in String array for the items in the cart.
    @Published var items: [String] = []

    @Published var isAllSet: OptInView.LoadState = .initializing

    func initializeWidget() {
        guard let categoryModel = CategoryModelInstance.shared.categoryModel else {
            isAllSet = .noCategoryMappingInfo
            UserDefaults.standard.OrderOptedIn = false
            return
        }
        if items.isEmpty {
            isAllSet = .paramIssue
            UserDefaults.standard.OrderOptedIn = false
            return
        }
        isAllSet = categoryModel.checkCategoryEligible(items: items).eligible ? .eligible : .notEligible
        UserDefaults.standard.OrderOptedIn = categoryModel.checkCategoryEligible(items: items).eligible && UserDefaults.standard.OptedIn ? true : false
    }
}
#endif

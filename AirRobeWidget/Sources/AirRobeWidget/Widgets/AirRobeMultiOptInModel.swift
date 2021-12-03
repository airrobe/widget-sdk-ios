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
        case initializing = "Widget Initializing"
        case eligible
        case notEligible
        case invalidMappingInfo = "Please initialize the sdk with your AppID and Secret Key"
        case paramIssue = "Please initialize the widget with the valid information"
    }

    /// The instance of the parent view controller
    var vc: UIViewController = UIViewController()
    /// Describes the categorys mapping info in String array for the items in the cart.
    var items: [String] = []

    @Published var isAllSet: LoadState = .initializing

    func initializeWidget() {
        if items.isEmpty {
            isAllSet = .paramIssue
            return
        }
        checkCategories()
    }
}

private extension AirRobeMultiOtpInModel {

    func checkCategories() {
        guard let categoryMappingInfo = UserDefaults.standard.categoryMappingInfo else {
            isAllSet = .invalidMappingInfo
            return
        }
        isAllSet = categoryMappingInfo.checkCategoryEligible(items: items).eligible ? .eligible : .notEligible
    }

}
#endif

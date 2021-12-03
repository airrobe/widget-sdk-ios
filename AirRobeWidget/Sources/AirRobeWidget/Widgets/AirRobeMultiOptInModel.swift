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
        case paramIssue = "Please initialize the widget with the valid information"
    }

    /// The instance of the parent view controller
    var vc: UIViewController = UIViewController()
    /// Describes the categorys mapping info in String array for the items in the cart.
    var items: [String] = []

    @Published var isAllSet: LoadState = .initializing

    func initializeWidget(categoryModel: CategoryModel) {
        if items.isEmpty {
            isAllSet = .paramIssue
            return
        }
        isAllSet = categoryModel.checkCategoryEligible(items: items).eligible ? .eligible : .notEligible
    }
}
#endif

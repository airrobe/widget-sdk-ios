//
//  AirRobeConfirmationModel.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeConfirmationModel {

    enum LoadState: String {
        case initializing = "Widget Initializing"
        case eligible
        case notEligible
        case paramIssue = "Please initialize the widget with the valid information"
    }

    /// Describes the order Id of the purchase.
    var orderId: String = ""
    var email: String?

    @Published var isAllSet: LoadState = .initializing

    func initializeWidget() {
        if orderId.isEmpty {
            isAllSet = .paramIssue
            return
        }
        isAllSet = UserDefaults.standard.OtpInfo && UserDefaults.standard.Eligibility ? .eligible : .notEligible
    }
}
#endif

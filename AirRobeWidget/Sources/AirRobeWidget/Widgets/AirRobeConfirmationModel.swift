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
        case notInitialized = "Widget Initializing"
        case loaded
        case loadedButInvisible
        case loadedWithMappingInfoIssue = "Please initialize the sdk with your AppID and Secret Key"
        case loadedWithParamIssue = "Please initialize the widget with the valid information"
    }

    /// Describes the order Id of the purchase.
    var orderId: String = ""
    var email: String?

    @Published var isAllSet: LoadState = .notInitialized

    func initializeWidget() {
        if orderId.isEmpty {
            isAllSet = .loadedWithParamIssue
            return
        }
        checkEligibility()
    }
}

private extension AirRobeConfirmationModel {

    func checkEligibility() {
        isAllSet = .loaded
    }

}
#endif

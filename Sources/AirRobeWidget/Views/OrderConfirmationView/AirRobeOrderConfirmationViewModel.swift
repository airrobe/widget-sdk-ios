//
//  AirRobeOrderConfirmationViewModel.swift
//  
//
//  Created by King on 12/17/21.
//

import Foundation
import Combine

final class AirRobeOrderConfirmationViewModel {

    /// Describes the order Id of the purchase.
    var orderId: String = ""
    /// Describes the email of the logged in account.
    var email: String = ""
    /// Describes the fraud status of the widget.
    var fraudRisk: Bool = false

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?
    var alreadyInitialized: Bool = false

    @Published var isAllSet: AirRobeWidgetLoadState = .initializing
    @Published var activateText: String = ""

    func initializeConfirmationWidget() {
        if !alreadyInitialized {
            alreadyInitialized = true
            if orderId.isEmpty || email.isEmpty {
                isAllSet = .paramIssue
                return
            }
            isAllSet = UserDefaults.standard.OrderOptedIn && !fraudRisk ? .eligible : .notEligible
            if isAllSet == .eligible {
                emailCheck(email: email)
            }
        }
    }

}

private extension AirRobeOrderConfirmationViewModel {

    func emailCheck(email: String) {
        cancellable = apiService.emailCheck(operation: AirRobeGraphQLOperation.fetchPost(with: email))
            .sink(receiveCompletion: { [weak self] (completion) in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("Email Checking Issue: ", error)
                    #endif
                    self.activateText = AirRobeStrings.orderConfirmationActivateText
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                self.activateText = $0.data.isCustomer ? AirRobeStrings.orderConfirmationVisitText : AirRobeStrings.orderConfirmationActivateText
            })
    }

}

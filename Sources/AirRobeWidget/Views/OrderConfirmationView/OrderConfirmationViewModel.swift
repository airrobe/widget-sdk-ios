//
//  OrderConfirmationViewModel.swift
//  
//
//  Created by King on 12/17/21.
//

import Foundation
import Combine

final class OrderConfirmationViewModel {

    /// Describes the order Id of the purchase.
    var orderId: String = ""
    /// Describes the email of the logged in account.
    var email: String = ""
    /// Describes the fraud status of the widget.
    var fraudRisk: Bool = false

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?

    @Published var isAllSet: WidgetLoadState = .initializing
    @Published var activateText: String = ""

    func initializeConfirmationWidget() {
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

private extension OrderConfirmationViewModel {

    func emailCheck(email: String) {
        cancellable = apiService.emailCheck(operation: GraphQLOperation.fetchPost(with: email))
            .sink(receiveCompletion: { [weak self] (completion) in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("Email Checking Issue: ", error)
                    #endif
                    self.activateText = Strings.orderConfirmationActivateText
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                self.activateText = $0.data.isCustomer ? Strings.orderConfirmationVisitText : Strings.orderConfirmationActivateText
            })
    }

}

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
    private var emailCheckCancellable, identifyOrderCancellable: AnyCancellable?
    var alreadyInitialized: Bool = false

    @Published var isAllSet: AirRobeWidgetLoadState = .initializing
    @Published var activateText: String = ""

    func initializeConfirmationWidget() {
        if !alreadyInitialized {
            AirRobeUtils.telemetryEvent(eventName: EventName.pageView.rawValue, pageName: PageName.thankYou.rawValue)
            alreadyInitialized = true
            if orderId.isEmpty || email.isEmpty {
                isAllSet = .paramIssue
                return
            }
            isAllSet = UserDefaults.standard.OrderOptedIn && !fraudRisk ? .eligible : .notEligible
            if isAllSet == .eligible {
                AirRobeUtils.dispatchEvent(eventName: EventName.confirmationRender.rawValue, pageName: PageName.thankYou.rawValue)
                emailCheck(email: email)

                identifyOrderCancellable = apiService.identifyOrder(orderId: orderId, orderOptedIn: UserDefaults.standard.OrderOptedIn)
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            #if DEBUG
                            print("Identify Order Call Issue: ", error)
                            #endif
                        case .finished:
                            print(completion)
                        }
                    }, receiveValue: { _ in
                        
                    })
            }
        }
    }

}

private extension AirRobeOrderConfirmationViewModel {

    func emailCheck(email: String) {
        emailCheckCancellable = apiService.emailCheck(operation: AirRobeGraphQLOperation.fetchPost(with: email))
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

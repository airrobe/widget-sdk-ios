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
    /// Describes the sub total amount of the order in cents
    var orderSubtotalCents: Int?
    /// Describes the currency of the order
    var currency: String = "AUD"
    /// Describes the fraud status of the widget.
    var fraudRisk: Bool = false

    private lazy var apiService = AirRobeApiService()
    private var emailCheckCancellable, identifyOrderCancellable, createOptedOutOrderCancellable: AnyCancellable?
    var alreadyInitialized: Bool = false

    @Published var isAllSet: AirRobeWidgetLoadState = .initializing
    @Published var activateText: String = ""

    func initializeConfirmationWidget() {
        if let testVariant = AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.getTargetSplitTestVariant(),
           !testVariant.enabled {
            isAllSet = .widgetDisabled
            return
        }

        if !alreadyInitialized {
            AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.pageView.rawValue, pageName: PageName.thankYou.rawValue)
            AirRobeUtils.dispatchEvent(eventName: EventName.pageView.rawValue, pageName: PageName.thankYou.rawValue)
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
            } else {
                guard let orderSubtotalCents = orderSubtotalCents, let appId = configuration?.appId else {
                    return
                }
                createOptedOutOrder(appId: appId, orderId: orderId, orderSubtotalCents: orderSubtotalCents, currency: currency)
            }
        }
    }

}

private extension AirRobeOrderConfirmationViewModel {

    func emailCheck(email: String) {
        emailCheckCancellable = apiService.emailCheck(operation: AirRobeGraphQLOperation.fetchPost(with: email))
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("Email Checking Issue: ", error)
                    #endif
                    self?.activateText = AirRobeStrings.orderConfirmationActivateText
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                self?.activateText = $0.data.isCustomer ? AirRobeStrings.orderConfirmationVisitText : AirRobeStrings.orderConfirmationActivateText
            })
    }

    func createOptedOutOrder(appId: String, orderId: String, orderSubtotalCents: Int, currency: String) {
        createOptedOutOrderCancellable = apiService.createOptedOutOrder(operation: AirRobeGraphQLOperation.fetchPost(with: appId, with: orderId, with: orderSubtotalCents, with: currency))
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("Create Opted Out Order Issue: ", error)
                    #endif
                case .finished:
                    print(completion)
                }
            }, receiveValue: { result in
                #if DEBUG
                print("Create Opted Out Order Data", result.data.createOptedOutOrder)
                #endif
            })
    }

}

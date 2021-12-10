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
        case paramIssue = "orderId and email shouldn't be empty string"
    }

    /// Describes the order Id of the purchase.
    var orderId: String = ""
    var email: String = ""

    private lazy var apiService = AirRobeApiService()
    private var cancellable: AnyCancellable?

    @Published var isAllSet: LoadState = .initializing
    @Published var activateText: String = ""

    func initializeWidget() {
        if orderId.isEmpty || email.isEmpty {
            isAllSet = .paramIssue
            return
        }
        isAllSet = UserDefaults.standard.OptInfo && UserDefaults.standard.Eligibility ? .eligible : .notEligible
        if isAllSet == .eligible {
            emailCheck(email: email)
        }
    }

}

private extension AirRobeConfirmationModel {

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
                    self.activateText = Strings.orderconrifmrationActivateText
                case .finished:
                    print(completion)
                }
            }, receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                self.activateText = $0.data.isCustomer ? Strings.orderconrifmrationVisitText : Strings.orderconrifmrationActivateText
            })
    }

}
#endif

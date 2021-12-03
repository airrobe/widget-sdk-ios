//
//  AirRobeConfirmation.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeConfirmation: UIView {
    private lazy var orderConfirmationView: OrderConfirmationView = OrderConfirmationView.loadFromNib()
    private(set) lazy var viewModel = AirRobeConfirmationModel()
    private var subscribers: [AnyCancellable] = []
    private var initialized: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func initialize(
        orderId: String,
        email: String? = nil
    ) {
        viewModel.orderId = orderId
        viewModel.email = email
        setupBindings()
    }

    private func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OtpInfo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (otpInfo) in
                guard let self = self else {
                    return
                }
                self.viewModel.isAllSet = otpInfo && UserDefaults.standard.Eligibility ? .eligible : .notEligible
            }).store(in: &subscribers)

        UserDefaults.standard
            .publisher(for: \.Eligibility)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (eligibility) in
                guard let self = self else {
                    return
                }
                self.viewModel.isAllSet = eligibility && UserDefaults.standard.OtpInfo ? .eligible : .notEligible
            }).store(in: &subscribers)

        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                guard let self = self else {
                    return
                }
                switch allSet {
                case .initializing:
                    #if DEBUG
                    print(AirRobeOtpInModel.LoadState.initializing.rawValue)
                    #endif
                case .eligible:
                    self.initView()
                case .notEligible:
                    self.isHidden = true
                case .paramIssue:
                    self.isHidden = true
                    #if DEBUG
                    print(AirRobeOtpInModel.LoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)
    }

    private func initView() {
        if !initialized {
            orderConfirmationView.activateButton.addTarget(self, action: #selector(onTapActivate), for: .touchUpInside)
            addSubview(orderConfirmationView)
            orderConfirmationView.frame = bounds
            orderConfirmationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            initialized = true
        }
        isHidden = false
    }

    @objc func onTapActivate(_ sender: UIButton) {
        let url = URL(string: "\(Strings.orderActivateBaseUrl)\(viewModel.orderId)-\(UserDefaults.standard.AppId)")
        guard let url = url else {
            return
        }
        Utils.openUrl(url)
    }
}
#endif

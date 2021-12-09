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
        viewModel.initializeWidget()
    }

    private func initView() {
        if !initialized {
            orderConfirmationView.activateButton.addTarget(self, action: #selector(onTapActivate), for: .touchUpInside)
            addSubview(orderConfirmationView)
            orderConfirmationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                orderConfirmationView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                orderConfirmationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                orderConfirmationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                orderConfirmationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            ])
            initialized = true
        }
        isHidden = false
    }

    @objc func onTapActivate(_ sender: UIButton) {
        guard let configuration = configuration else {
            return
        }
        let url = URL(
            string: "\(Strings.orderActivateBaseUrl)\(configuration.appId)-\(viewModel.orderId)"
        )
        guard let url = url else {
            return
        }
        Utils.openUrl(url)
    }
}

private extension AirRobeConfirmation {
    func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OptInfo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (optInfo) in
                guard let self = self else {
                    return
                }
                self.viewModel.isAllSet = optInfo && UserDefaults.standard.Eligibility ? .eligible : .notEligible
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
                self.viewModel.isAllSet = eligibility && UserDefaults.standard.OptInfo ? .eligible : .notEligible
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
                    print(AirRobeOptInModel.LoadState.initializing.rawValue)
                    #endif
                case .eligible:
                    self.initView()
                case .notEligible:
                    self.isHidden = true
                case .paramIssue:
                    self.isHidden = true
                    #if DEBUG
                    print(AirRobeOptInModel.LoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)

        viewModel.$activateText
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] activateText in
                guard let self = self, !activateText.isEmpty else {
                    return
                }
                self.orderConfirmationView.activateLoading.stopAnimating()
                self.orderConfirmationView.activateLabel.text = activateText
            }).store(in: &subscribers)
    }
}
#endif

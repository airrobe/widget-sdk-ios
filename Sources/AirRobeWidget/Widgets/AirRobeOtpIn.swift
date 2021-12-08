//
//  AirRobeOtpIn.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeOtpIn: UIView {
    private(set) lazy var viewModel = AirRobeOtpInModel()
    private var subscribers: [AnyCancellable] = []
    private lazy var otpInview: OtpInView = OtpInView.loadFromNib()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func initialize(
        brand: String,
        material: String,
        category: String,
        priceCents: String,
        originalFullPriceCents: String,
        rrpCents: String,
        currency: String,
        locale: String
    ) {
        viewModel.brand = brand
        viewModel.material = material
        viewModel.category = category
        viewModel.priceCents = priceCents
        viewModel.originalFullPriceCents = originalFullPriceCents
        viewModel.rrpCents = rrpCents
        viewModel.currency = currency
        viewModel.locale = locale

        setupBindings()
        if let categoryModel = CategoryModelInstance.shared.categoryModel {
            viewModel.initializeWidget(categoryModel: categoryModel)
        }
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
                self.otpInview.addToAirRobeSwitch.isOn = otpInfo
            }).store(in: &subscribers)

        CategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] categoryModel in
                guard let self = self, let categoryModel = categoryModel else {
                    return
                }
                self.viewModel.initializeWidget(categoryModel: categoryModel)
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
                case .priceEngineIssue:
                    #if DEBUG
                    print(AirRobeOtpInModel.LoadState.priceEngineIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)

        viewModel.$potentialPrice
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] price in
                guard let self = self, !price.isEmpty else {
                    return
                }
                DispatchQueue.main.async {
                    self.otpInview.potentialValueLoading.stopAnimating()
                    self.otpInview.potentialValueLabel.text = Strings.potentialValue + "$" + price
                }
            }).store(in: &subscribers)
    }

    private func initViewWithError(error: String) {
        let errorLabel: UILabel = {
            let v = UILabel()
            v.textColor = .red
            v.font = .systemFont(ofSize: 16)
            v.text = error
            v.textAlignment = .center
            v.lineBreakMode = .byWordWrapping
            v.numberOfLines = 0
            return v
        }()
        addSubview(errorLabel)
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        errorLabel.frame = bounds
        errorLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func initView() {
        otpInview.potentialValueLoading.startAnimating()
        addSubview(otpInview)
        otpInview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otpInview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            otpInview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            otpInview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            otpInview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
    }
}
#endif

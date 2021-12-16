//
//  AirRobeOptIn.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeOptIn: UIView {
    private(set) lazy var viewModel = AirRobeOptInModel()
    private var subscribers: [AnyCancellable] = []
    private lazy var optInview: OptInView = OptInView.loadFromNib()
    private var isAdded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBindings()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBindings()
    }

    public func initialize(
        brand: String? = nil,
        material: String? = nil,
        category: String,
        priceCents: Double,
        originalFullPriceCents: Double? = nil,
        rrpCents: Double? = nil,
        currency: String? = "AUD",
        locale: String? = "en-AU"
    ) {
        viewModel.brand = brand
        viewModel.material = material
        viewModel.category = category
        viewModel.priceCents = priceCents
        viewModel.originalFullPriceCents = originalFullPriceCents
        viewModel.rrpCents = rrpCents
        viewModel.currency = currency
        viewModel.locale = locale

        viewModel.initializeWidget()
    }

    private func initView() {
        optInview.potentialValueLoading.startAnimating()
        if !isAdded {
            addSubview(optInview)
            optInview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                optInview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                optInview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                optInview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                optInview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            ])
            isAdded = true
        }
    }
}

private extension AirRobeOptIn {
    func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OptedIn)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (optInfo) in
                guard let self = self else {
                    return
                }
                self.optInview.addToAirRobeSwitch.isOn = optInfo
            }).store(in: &subscribers)

        CategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (categoryModel) in
                guard let self = self, categoryModel != nil else {
                    return
                }
                self.viewModel.initializeWidget()
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
                    print(OptInView.LoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    #if DEBUG
                    print(OptInView.LoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self.initView()
                case .notEligible:
                    self.isHidden = true
                case .paramIssue:
                    self.isHidden = true
                    #if DEBUG
                    print(OptInView.LoadState.paramIssue.rawValue)
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
                    self.optInview.potentialValueLoading.stopAnimating()
                    self.optInview.potentialValueLabel.text = Strings.potentialValue + "$" + price
                }
            }).store(in: &subscribers)
    }
}
#endif

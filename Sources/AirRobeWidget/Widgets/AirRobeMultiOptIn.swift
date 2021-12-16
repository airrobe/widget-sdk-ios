//
//  AirRobeMultiOptIn.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeMultiOptIn: UIView {
    private(set) lazy var viewModel = AirRobeMultiOptInModel()
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
        items: [String]
    ) {
        viewModel.items = items
    }

    /// When the cart is updated, we are supposed to call this function
    public func updateCategories(
        items: [String]
    ) {
        viewModel.items = items
    }

    private func initView() {
        optInview.potentialValueLabel.isHidden = true
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

private extension AirRobeMultiOptIn {
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
                UserDefaults.standard.OrderOptedIn = self.viewModel.isAllSet == .eligible && optInfo ? true : false
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
                    self?.initView()
                case .notEligible:
                    self?.isHidden = true
                case .paramIssue:
                    self?.isHidden = true
                    #if DEBUG
                    print(OptInView.LoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)

        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (items) in
                self?.viewModel.initializeWidget()
            }).store(in: &subscribers)
    }
}
#endif

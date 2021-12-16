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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func initialize(
        items: [String]
    ) {
        viewModel.items = items

        setupBindings()
        if let categoryModel = CategoryModelInstance.shared.categoryModel {
            viewModel.initializeWidget(categoryModel: categoryModel)
        }
    }

    private func initView() {
        optInview.potentialValueLabel.isHidden = true
        addSubview(optInview)
        optInview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optInview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            optInview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            optInview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            optInview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
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
    }
}
#endif

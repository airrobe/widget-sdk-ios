//
//  WidgetOnShop.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit
import Combine

public enum ExpandState {
    case opened
    case closed
}

public enum SwitchState {
    case added
    case notAdded
}

open class WidgetOnShop: UIView {
    private(set) lazy var viewModel = WidgetOnShopModel()
    private var subscribers: [AnyCancellable] = []
    private lazy var widgetOnShop: OnShopView = OnShopView.loadFromNib()
    private var expandType: ExpandState = .closed
    private var switchState: SwitchState = .notAdded

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
        viewModel.initializeWidget()
    }

    private func setupBindings() {
        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                guard let self = self else {
                    return
                }
                switch allSet {
                case .notInitialized:
                    break
                case .loaded:
                    self.initView()
                case .loadedButInvisible:
                    self.isHidden = true
                case .loadedWithMappingInfoIssue:
                    self.initViewWithError(error: WidgetOnShopModel.LoadState.loadedWithMappingInfoIssue.rawValue)
                case .loadedWithParamIssue:
                    self.initViewWithError(error: WidgetOnShopModel.LoadState.loadedWithParamIssue.rawValue)
                case .loadedWithPriceEngineIssue:
                    self.initViewWithError(error: WidgetOnShopModel.LoadState.loadedWithPriceEngineIssue.rawValue)
                }
            }).store(in: &subscribers)

        viewModel.$potentialPrice
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] price in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.widgetOnShop.potentialValueLabel.text = Strings.potentialValue + "$" + price
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
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        errorLabel.frame = self.bounds
        errorLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func initView() {
        // Widget Border Style
        widgetOnShop.mainContainerView.layer.borderColor = UIColor.black.cgColor
        widgetOnShop.mainContainerView.layer.borderWidth = 1

        // Initializing Static Texts & Links
        widgetOnShop.titleLabel.text = Strings.add
        widgetOnShop.descriptionLabel.text = Strings.description
        widgetOnShop.potentialValueLabel.text = Strings.potentialValue

        widgetOnShop.detailedDescriptionLabel.setLinkText(
            orgText: Strings.detailedDescription,
            linkText: Strings.learnMoreLinkText,
            link: Strings.learnMoreLinkText)
        widgetOnShop.detailedDescriptionLabel.isHidden = true
        widgetOnShop.margin.isHidden = true
        widgetOnShop.extraInfoLabel.setLinkText(
            orgText: Strings.extraInfo,
            linkText: Strings.extraLinkText,
            link: Strings.extraLink)

        widgetOnShop.addToAirRobeSwitch.isOn = false
        widgetOnShop.addToAirRobeSwitch.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)

        widgetOnShop.mainContainerExpandButton.setTitle("", for: .normal)
        widgetOnShop.mainContainerExpandButton.addTarget(self, action: #selector(onTapExpand), for: .touchUpInside)

        addSubview(widgetOnShop)
        widgetOnShop.frame = self.bounds
        widgetOnShop.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        widgetOnShop.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    @objc func onTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            switchState = .added
            widgetOnShop.titleLabel.text = Strings.added
        } else {
            switchState = .notAdded
            widgetOnShop.titleLabel.text = Strings.add
        }
    }

    @objc func onTapExpand(_ sender: UIButton) {
        var degree = 0.0
        switch expandType {
        case .opened:
            expandType = .closed
            degree = 0.0
        case .closed:
            expandType = .opened
            degree = 1.0
        }

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.widgetOnShop.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
            self.widgetOnShop.detailedDescriptionLabel.isHidden.toggle()
            self.widgetOnShop.margin.isHidden.toggle()
            self.widgetOnShop.widgetStackView.layoutIfNeeded()
        })
    }

    open func isExpanded() -> ExpandState {
        return expandType
    }
}
#endif

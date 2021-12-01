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
    private let activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.hidesWhenStopped = true
        v.style = .medium
        return v
    }()

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

        initViewWithLoadingIndicator()
        setupBindings()
        if UserDefaults.standard.shouldLoadWidget {
            self.viewModel.initializeWidget()
        }
    }

    private func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.shouldLoadWidget)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (shouldLoadWidget) in
                guard let self = self, shouldLoadWidget else {
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
                case .notInitialized:
                    break
                case .loaded:
                    self.initView()
                case .loadedButInvisible:
                    self.isHidden = true
                case .loadedWithMappingInfoIssue:
                    self.initViewWithError(error: WidgetOnShopModel.LoadState.loadedWithMappingInfoIssue.rawValue)
                case .loadedWithParamIssue:
                    self.isHidden = true
                    #if DEBUG
                    print(WidgetOnShopModel.LoadState.loadedWithParamIssue.rawValue)
                    #endif
                case .loadedWithPriceEngineIssue:
                    #if DEBUG
                    print(WidgetOnShopModel.LoadState.loadedWithPriceEngineIssue.rawValue)
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
                    self.widgetOnShop.potentialValueLoading.stopAnimating()
                    self.widgetOnShop.potentialValueLabel.text = Strings.potentialValue + "$" + price
                }
            }).store(in: &subscribers)
    }

    private func initViewWithLoadingIndicator() {
        addSubview(activityIndicator)
        activityIndicator.frame = bounds
        activityIndicator.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }

    private func initViewWithError(error: String) {
        // Remove loading indicator when data loads out
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()

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
        // Remove loading indicator when data loads out
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()

        // Widget Border Style
        widgetOnShop.mainContainerView.layer.borderColor = UIColor.black.cgColor
        widgetOnShop.mainContainerView.layer.borderWidth = 1

        // Initializing Static Texts & Links
        widgetOnShop.titleLabel.text = UserDefaults.standard.OtpInfo ? Strings.added : Strings.add
        widgetOnShop.descriptionLabel.text = Strings.description
        widgetOnShop.potentialValueLabel.text = Strings.potentialValue
        widgetOnShop.potentialValueLoading.hidesWhenStopped = true
        widgetOnShop.potentialValueLoading.startAnimating()

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

        widgetOnShop.addToAirRobeSwitch.isOn = UserDefaults.standard.OtpInfo
        widgetOnShop.addToAirRobeSwitch.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)

        widgetOnShop.mainContainerExpandButton.setTitle("", for: .normal)
        widgetOnShop.mainContainerExpandButton.addTarget(self, action: #selector(onTapExpand), for: .touchUpInside)

        addSubview(widgetOnShop)
        widgetOnShop.frame = bounds
        widgetOnShop.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        widgetOnShop.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    @objc func onTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            switchState = .added
            widgetOnShop.titleLabel.text = Strings.added
            UserDefaults.standard.OtpInfo = true
        } else {
            switchState = .notAdded
            widgetOnShop.titleLabel.text = Strings.add
            UserDefaults.standard.OtpInfo = false
        }
    }

    @objc func onTapExpand(_ sender: UIButton) {
        let degree: CGFloat = {
            switch expandType {
            case .opened:
                expandType = .closed
                return 0.0
            case .closed:
                expandType = .opened
                return 1.0
            }
        }()

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

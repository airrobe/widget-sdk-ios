//
//  DefaultOptInView.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit
import Combine

// AirRobe view which will be shown on Shopping page.
final class DefaultOptInView: UIView, NibLoadable {
    @IBOutlet weak var widgetStackView: UIStackView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var topContentContainer: UIStackView!
    @IBOutlet weak var extraInfoContainer: UIView!
    @IBOutlet weak var extraInfoLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potentialValueLabel: UILabel!
    @IBOutlet weak var potentialValueLoading: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var subTitleContainer: UIStackView!

    private let EXTRA_PADDING_FOR_DESCRIPTION_LABEL_MAX_WIDTH = 20.0

    enum ExpandState {
        case opened
        case closed
    }

    enum ViewType {
        case optIn
        case multiOptIn
    }

    var superView: UIView?
    var viewType: ViewType = .optIn
    private var alreadyAdded: Bool = false
    private var descriptionValueLabelMaxWidth: CGFloat = 0.0
    private(set) lazy var viewModel = AirRobeOptInViewModel()
    private var subscribers: [AnyCancellable] = []
    private var expandType: ExpandState = .closed

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func layoutSubviews() {
        let maxWidth = usableHorizontalSpace()
        if descriptionValueLabelMaxWidth != maxWidth {
            descriptionValueLabelMaxWidth = maxWidth
            guard let value = descriptionLabel.text, value.isEmpty || value == AirRobeDefaultStrings.description else {
                return
            }
            if ((AirRobeDefaultStrings.description).width(withFont: descriptionLabel.font).width + EXTRA_PADDING_FOR_DESCRIPTION_LABEL_MAX_WIDTH) > descriptionValueLabelMaxWidth {
                descriptionLabel.text = AirRobeDefaultStrings.descriptionCutOffText
            } else {
                descriptionLabel.text = AirRobeDefaultStrings.description
            }
        }
    }

    private func usableHorizontalSpace() -> CGFloat {
        return subTitleContainer.bounds.width - potentialValueLabel.bounds.width - potentialValueLoading.bounds.width
    }

    private func commonInit() {
        // Widget Border Style
        mainContainerView.addBorder(cornerRadius: 0)

        let tapOnArrowImage = UITapGestureRecognizer(target: self, action:  #selector(onTapArrow))
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(tapOnArrowImage)

        let tapOnTopContentContainer = UITapGestureRecognizer(target: self, action:  #selector(onTapArrow))
        topContentContainer.addGestureRecognizer(tapOnTopContentContainer)

        // Initializing Static Texts & Links
        titleLabel.text = UserDefaults.standard.OptedIn ? AirRobeDefaultStrings.added : AirRobeDefaultStrings.add
        descriptionLabel.text = AirRobeDefaultStrings.description
        potentialValueLabel.text = AirRobeDefaultStrings.potentialValue
        potentialValueLoading.hidesWhenStopped = true
        potentialValueLoading.startAnimating()

        detailedDescriptionLabel.setLinkText(
            orgText: AirRobeDefaultStrings.detailedDescription,
            linkText: AirRobeDefaultStrings.learnMoreLinkText,
            link: AirRobeDefaultStrings.learnMoreLinkForPurpose,
            tapHandler: onTapLearnMore)
        detailedDescriptionLabel.isHidden = true

        if let privacyLink = URL(string: AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.data.shop.privacyUrl ?? "") {
            extraInfoContainer.isHidden = false
            let extraInfo = AirRobeDefaultStrings.extraInfo.replacingOccurrences(of: AirRobeDefaultStrings.companyNameText, with: AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.data.shop.name ?? "")
            extraInfoLabel.setLinkText(
                orgText: extraInfo,
                linkText: AirRobeDefaultStrings.extraLinkText,
                link: privacyLink,
                tapHandler: onTapExtraInfoLink)
        } else {
            extraInfoContainer.isHidden = true
            #if DEBUG
            print("Privacy policy url is not valid.")
            #endif
        }

        addToAirRobeSwitch.isOn = UserDefaults.standard.OptedIn
        arrowImageView.image = arrowImageView.image?.withRenderingMode(.alwaysTemplate)
        setupBindings()
    }

    private func onTapExtraInfoLink(_ url: URL) {
        AirRobeUtils.openUrl(url)
    }

    private func onTapLearnMore(_ url: URL) {
        guard let vc = parentViewController else {
            return
        }
        let alert = DefaultLearnMoreAlertViewController.instantiate()
        alert.modalPresentationStyle = .overCurrentContext
        alert.viewType = viewType
        vc.present(alert, animated: true)
        if viewType == .optIn {
            AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.popupOpen.rawValue, pageName: PageName.product.rawValue)
            AirRobeUtils.dispatchEvent(eventName: EventName.popupOpen.rawValue, pageName: PageName.product.rawValue)
        } else {
            AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.popupOpen.rawValue, pageName: PageName.cart.rawValue)
            AirRobeUtils.dispatchEvent(eventName: EventName.popupOpen.rawValue, pageName: PageName.cart.rawValue)
        }
    }

    @IBAction func onTapSwitch(_ sender: UISwitch) {
        titleLabel.text = sender.isOn ? AirRobeDefaultStrings.added : AirRobeDefaultStrings.add
        UserDefaults.standard.OptedIn = sender.isOn
        if sender.isOn {
            if viewType == .optIn {
                AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.optIn.rawValue, pageName: PageName.product.rawValue)
                AirRobeUtils.dispatchEvent(eventName: EventName.optIn.rawValue, pageName: PageName.product.rawValue)
            } else {
                AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.optIn.rawValue, pageName: PageName.cart.rawValue)
                AirRobeUtils.dispatchEvent(eventName: EventName.optIn.rawValue, pageName: PageName.cart.rawValue)
            }
        } else {
            if viewType == .optIn {
                AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.optOut.rawValue, pageName: PageName.product.rawValue)
                AirRobeUtils.dispatchEvent(eventName: EventName.optOut.rawValue, pageName: PageName.product.rawValue)
            } else {
                AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.optOut.rawValue, pageName: PageName.cart.rawValue)
                AirRobeUtils.dispatchEvent(eventName: EventName.optOut.rawValue, pageName: PageName.cart.rawValue)
            }
        }
    }

    @objc func onTapArrow(_ sender: UITapGestureRecognizer) {
        onExpand()
    }

    func onExpand() {
        let degree: CGFloat = {
            switch expandType {
            case .opened:
                expandType = .closed
                if viewType == .optIn {
                    AirRobeUtils.dispatchEvent(eventName: EventName.collapse.rawValue, pageName: PageName.product.rawValue)
                } else {
                    AirRobeUtils.dispatchEvent(eventName: EventName.collapse.rawValue, pageName: PageName.cart.rawValue)
                }
                return 0.0
            case .closed:
                expandType = .opened
                if viewType == .optIn {
                    AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.expand.rawValue, pageName: PageName.product.rawValue)
                    AirRobeUtils.dispatchEvent(eventName: EventName.expand.rawValue, pageName: PageName.product.rawValue)
                } else {
                    AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.expand.rawValue, pageName: PageName.cart.rawValue)
                    AirRobeUtils.dispatchEvent(eventName: EventName.expand.rawValue, pageName: PageName.cart.rawValue)
                }
                return 1.0
            }
        }()

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            self?.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
        })
        DefaultOptInView.performWithoutAnimation {
            tableView?.beginUpdates()
            detailedDescriptionLabel.isHidden.toggle()
            tableView?.endUpdates()
        }
    }
}

private extension DefaultOptInView {

    func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OptedIn)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (optInfo) in
                self?.addToAirRobeSwitch.isOn = optInfo
                if self?.viewType == .multiOptIn {
                    UserDefaults.standard.OrderOptedIn = self?.viewModel.isAllSet == .eligible && optInfo ? true : false
                }
            }).store(in: &subscribers)

        AirRobeShoppingDataModelInstance.shared.$shoppingDataModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (shoppingDataModel) in
                guard let self = self, shoppingDataModel != nil, !self.viewModel.alreadyInitialized else {
                    return
                }
                switch self.viewType {
                case .optIn:
                    self.viewModel.initializeOptInWidget()
                case .multiOptIn:
                    self.viewModel.initializeMultiOptInWidget()
                }
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
                    print(AirRobeWidgetLoadState.initializing.rawValue)
                    #endif
                case .widgetDisabled:
                    #if DEBUG
                    print(AirRobeWidgetLoadState.widgetDisabled.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    #if DEBUG
                    print(AirRobeWidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self.alreadyAdded = self.addToSuperView(superView: self.superView, alreadyAddedToTable: self.alreadyAdded)
                case .notEligible:
                    self.removeFromSuperview()
                case .paramIssue:
                    self.removeFromSuperview()
                    #if DEBUG
                    print(AirRobeWidgetLoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)

        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (items) in
                guard let self = self, self.viewType == .multiOptIn else {
                    return
                }
                self.potentialValueLabel.isHidden = true
                self.potentialValueLoading.isHidden = true
                self.viewModel.initializeMultiOptInWidget()
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
                    self.potentialValueLoading.stopAnimating()
                    self.potentialValueLabel.text = AirRobeDefaultStrings.potentialValue + "$" + price
                    if ((AirRobeDefaultStrings.description).width(withFont: self.descriptionLabel.font).width + self.EXTRA_PADDING_FOR_DESCRIPTION_LABEL_MAX_WIDTH) > self.descriptionValueLabelMaxWidth {
                        self.descriptionLabel.text = AirRobeDefaultStrings.descriptionCutOffText
                        return
                    }
                }
            }).store(in: &subscribers)
    }

}
#endif

//
//  AirRobeOptInView.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit
import Combine

// AirRobe view which will be shown on Shopping page.
final class AirRobeOptInView: UIView, NibLoadable {
    @IBOutlet weak var widgetStackView: UIStackView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerExpandButton: UIButton!
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var extraInfoLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potentialValueLabel: UILabel!
    @IBOutlet weak var potentialValueLoading: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var subTitleContainer: UIStackView!

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
    private var potentialValueLabelMaxWidth: CGFloat = 0.0
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
        let maxWidth = subTitleContainer.bounds.width - descriptionLabel.bounds.width - 10 - potentialValueLoading.bounds.width
        if potentialValueLabelMaxWidth != maxWidth {
            potentialValueLabelMaxWidth = maxWidth
            guard let value = potentialValueLabel.text, value.isEmpty || value == AirRobeStrings.potentialValue else {
                return
            }
            if (AirRobeStrings.potentialValue).width(withFont: potentialValueLabel.font).width > potentialValueLabelMaxWidth {
                potentialValueLabel.text = ""
            } else {
                potentialValueLabel.text = AirRobeStrings.potentialValue
            }
        }
    }

    private func commonInit() {
        // Widget Border Style
        mainContainerView.addBorder(color: AirRobeBorderColor.cgColor, cornerRadius: 0)

        // Initializing Static Texts & Links
        titleLabel.text = UserDefaults.standard.OptedIn ? AirRobeStrings.added : AirRobeStrings.add
        descriptionLabel.text = AirRobeStrings.description
        potentialValueLoading.hidesWhenStopped = true
        potentialValueLoading.startAnimating()

        guard let appConfig = configuration else {
            #if DEBUG
            print("Widget is not yet configured.")
            #endif
            return
        }
        guard let privacyLink = URL(string: appConfig.privacyPolicyURL) else {
            #if DEBUG
            print("Privacy policy url is not valid.")
            #endif
            return
        }
        detailedDescriptionLabel.setLinkText(
            orgText: AirRobeStrings.detailedDescription,
            linkText: AirRobeStrings.learnMoreLinkText,
            link: privacyLink,
            tapHandler: onTapLearnMore)
        detailedDescriptionLabel.isHidden = true
        margin.isHidden = true
        extraInfoLabel.setLinkText(
            orgText: AirRobeStrings.extraInfo,
            linkText: AirRobeStrings.extraLinkText,
            link: privacyLink,
            tapHandler: onTapExtraInfoLink)
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
        let alert = AirRobeLearnMoreAlertViewController.instantiate()
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
        titleLabel.text = sender.isOn ? AirRobeStrings.added : AirRobeStrings.add
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

    @IBAction func onTapExpand(_ sender: Any) {
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
        tableView?.beginUpdates()
        detailedDescriptionLabel.isHidden.toggle()
        margin.isHidden.toggle()
        tableView?.endUpdates()
    }
}

private extension AirRobeOptInView {

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
                    guard (AirRobeStrings.potentialValue + "$" + price).width(withFont: self.potentialValueLabel.font).width > self.potentialValueLabelMaxWidth else {
                        self.potentialValueLabel.text = AirRobeStrings.potentialValue + "$" + price
                        return
                    }
                    self.potentialValueLabel.text = "$" + price
                }
            }).store(in: &subscribers)
    }

}
#endif

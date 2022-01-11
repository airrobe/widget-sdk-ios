//
//  OptInView.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit
import Combine

// AirRobe view which will be shown on Shopping page.
final class OptInView: UIView, NibLoadable {
    @IBOutlet weak var widgetStackView: UIStackView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerExpandButton: UIButton!
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var extraInfoLabel: HyperlinkLabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var potentialValueLabel: UILabel!
    @IBOutlet weak var potentialValueLoading: UIActivityIndicatorView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: HyperlinkLabel!

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
    private(set) lazy var viewModel = OptInViewModel()
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

    private func commonInit() {
        // Widget Border Style
        mainContainerView.addBorder(cornerRadius: 0)

        // Initializing Static Texts & Links
        titleLabel.text = UserDefaults.standard.OptedIn ? Strings.added : Strings.add
        descriptionLabel.text = Strings.description
        potentialValueLabel.text = Strings.potentialValue
        potentialValueLoading.hidesWhenStopped = true
        potentialValueLoading.startAnimating()

        guard let appConfig = configuration, let privacyLink = URL(string: appConfig.privacyPolicyLinkForIconic) else {
            #if DEBUG
            fatalError("Privacy Policy is not valid")
            #endif
        }
        detailedDescriptionLabel.setLinkText(
            orgText: Strings.detailedDescription,
            linkText: Strings.learnMoreLinkText,
            link: privacyLink,
            tapHandler: onTapLearnMore)
        detailedDescriptionLabel.isHidden = true
        margin.isHidden = true
        extraInfoLabel.setLinkText(
            orgText: Strings.extraInfo,
            linkText: Strings.extraLinkText,
            link: privacyLink,
            tapHandler: onTapExtraInfoLink)

        addToAirRobeSwitch.isOn = UserDefaults.standard.OptedIn
        addToAirRobeSwitch.onTintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)
        addToAirRobeSwitch.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

        arrowImageView.image = arrowImageView.image?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

        setupBindings()
    }

    private func onTapExtraInfoLink(_ url: URL) {
        Utils.openUrl(url)
    }

    private func onTapLearnMore(_ url: URL) {
        guard let vc = parentViewController else {
            return
        }
        let alert = LearnMoreAlertViewController.instantiate()
        alert.modalPresentationStyle = .overCurrentContext
        vc.present(alert, animated: true)
    }

    @IBAction func onTapSwitch(_ sender: UISwitch) {
        titleLabel.text = sender.isOn ? Strings.added : Strings.add
        UserDefaults.standard.OptedIn = sender.isOn
    }

    @IBAction func onTapExpand(_ sender: Any) {
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
            self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
            self.detailedDescriptionLabel.isHidden.toggle()
            self.margin.isHidden.toggle()
            self.widgetStackView.layoutIfNeeded()
        })
    }
}

private extension OptInView {

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

        CategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (categoryModel) in
                guard let self = self, categoryModel != nil, !self.viewModel.alreadyInitialized else {
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
                switch allSet {
                case .initializing:
                    #if DEBUG
                    print(WidgetLoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    #if DEBUG
                    print(WidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self?.addToSuperView(superView: self?.superView)
                case .notEligible:
                    self?.removeFromSuperview()
                case .paramIssue:
                    self?.removeFromSuperview()
                    #if DEBUG
                    print(WidgetLoadState.paramIssue.rawValue)
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
                    self.potentialValueLabel.text = Strings.potentialValue + "$" + price
                }
            }).store(in: &subscribers)
    }

}
#endif

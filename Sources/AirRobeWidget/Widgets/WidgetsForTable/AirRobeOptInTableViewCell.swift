//
//  AirRobeOptInTableViewCell.swift
//  
//
//  Created by King on 2/10/22.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeOptInTableViewCell: UITableViewCell {
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

    public static let identifier = "AirRobeOptInTableViewCell"
    private var potentialValueLabelMaxWidth: CGFloat = 0.0
    private(set) lazy var viewModel = AirRobeOptInViewModel()
    private var subscribers: [AnyCancellable] = []
    private var expandType: ExpandState = .closed

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// initalizing AirRobeMultiOptIn
    /// - Parameters:
    ///   - brand: brand of the shopping item, optional value and can be dismissed
    ///   - material: material of the shopping item, optional value and can be dismissed
    ///   - category: category of the shopping item
    ///   - priceCents: price of the shopping item
    ///   - originalFullPriceCents: original full price of the shopping item, optional value and can be dismissed
    ///   - rrpCents: recommended retail price of the shopping item, optional value and can be dismissed
    ///   - currency: currency in 3 lettered characters, optional value and default value is "AUD"
    ///   - locale: locale, optional value and default value is "en-AU"
    public func initialize(
        brand: String? = nil,
        material: String? = nil,
        category: String,
        priceCents: Double,
        originalFullPriceCents: Double? = nil,
        rrpCents: Double? = nil,
        currency: String = "AUD",
        locale: String = "en-AU"
    ) {
        viewModel.brand = brand
        viewModel.material = material
        viewModel.category = category
        viewModel.priceCents = priceCents
        viewModel.originalFullPriceCents = originalFullPriceCents
        viewModel.rrpCents = rrpCents
        viewModel.currency = currency
        viewModel.locale = locale

        viewModel.initializeOptInWidget()
    }

    private func commonInit() {
        // Widget Border Style
        mainContainerView.addBorder(cornerRadius: 0)

        // Initializing Static Texts & Links
        titleLabel.text = UserDefaults.standard.OptedIn ? AirRobeStrings.added : AirRobeStrings.add
        descriptionLabel.text = AirRobeStrings.description
        potentialValueLoading.hidesWhenStopped = true
        potentialValueLoading.startAnimating()
        isHidden = true

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
        addToAirRobeSwitch.onTintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)
        addToAirRobeSwitch.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

        arrowImageView.image = arrowImageView.image?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

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
        vc.present(alert, animated: true)
    }

    @IBAction func onTapSwitch(_ sender: UISwitch) {
        titleLabel.text = sender.isOn ? AirRobeStrings.added : AirRobeStrings.add
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

private extension AirRobeOptInTableViewCell {

    func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OptedIn)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (optInfo) in
                self?.addToAirRobeSwitch.isOn = optInfo
            }).store(in: &subscribers)

        AirRobeCategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (categoryModel) in
                guard let self = self, categoryModel != nil, !self.viewModel.alreadyInitialized else {
                    return
                }
                self.viewModel.initializeOptInWidget()
            }).store(in: &subscribers)

        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                switch allSet {
                case .initializing:
                    self?.isHidden = true
                    #if DEBUG
                    print(AirRobeWidgetLoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    self?.isHidden = true
                    #if DEBUG
                    print(AirRobeWidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self?.isHidden = false
                case .notEligible:
                    self?.isHidden = true
                case .paramIssue:
                    self?.isHidden = true
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
                guard let self = self else {
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

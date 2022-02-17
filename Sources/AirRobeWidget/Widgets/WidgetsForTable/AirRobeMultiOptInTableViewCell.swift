//
//  AirRobeMultiOptInTableViewCell.swift
//  
//
//  Created by King on 2/17/22.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeMultiOptInTableViewCell: UITableViewCell {
    @IBOutlet weak var widgetStackView: UIStackView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerExpandButton: UIButton!
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var extraInfoLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var addToAirRobeSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var detailedDescriptionLabel: AirRobeHyperlinkLabel!

    enum ExpandState {
        case opened
        case closed
    }

    public static var reuseIdentifier: String { return "AirRobeMultiOptInTableViewCell" }
    public static var nib: UINib { return UINib(nibName: "AirRobeMultiOptInTableViewCell", bundle: .module) }
    private var potentialValueLabelMaxWidth: CGFloat = 0.0
    private(set) lazy var viewModel = AirRobeOptInViewModel()
    private var subscribers: [AnyCancellable] = []
    private var expandType: ExpandState = .closed

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    /// initalizing AirRobeMultiOptInTableViewCell
    /// - Parameters:
    ///   - items: A string array value that contains category of items that are in the shopping cart
    public func initialize(
        items: [String]
    ) {
        viewModel.items = items
        viewModel.initializeMultiOptInWidget()
    }

    /// When the cart is updated, we are supposed to call this function
    public func updateCategories(
        items: [String]
    ) {
        viewModel.items = items
    }

    private func commonInit() {
        // Widget Border Style
        mainContainerView.addBorder(cornerRadius: 0)

        // Initializing Static Texts & Links
        titleLabel.text = UserDefaults.standard.OptedIn ? AirRobeStrings.added : AirRobeStrings.add
        descriptionLabel.text = AirRobeStrings.description

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
        guard superview != nil, let tableView = superview as? UITableView else {
            return
        }
        tableView.beginUpdates()

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
            self?.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
        })
        detailedDescriptionLabel.isHidden.toggle()
        margin.isHidden.toggle()
        tableView.endUpdates()
    }
}

private extension AirRobeMultiOptInTableViewCell {

    func setupBindings() {
        UserDefaults.standard
            .publisher(for: \.OptedIn)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (optInfo) in
                self?.addToAirRobeSwitch.isOn = optInfo
                UserDefaults.standard.OrderOptedIn = self?.viewModel.isAllSet == .eligible && optInfo ? true : false
            }).store(in: &subscribers)

        AirRobeCategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] (categoryModel) in
                guard let self = self, categoryModel != nil, !self.viewModel.alreadyInitialized else {
                    return
                }
                self.viewModel.initializeMultiOptInWidget()
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
                self?.viewModel.initializeMultiOptInWidget()
            }).store(in: &subscribers)
    }
}
#endif

//
//  OnShopView.swift
//  
//
//  Created by King on 11/18/21.
//

#if canImport(UIKit)
import UIKit

// AirRobe view which will be shown on Shopping page.
final class OtpInView: UIView, NibLoadable {
    enum ExpandState {
        case opened
        case closed
    }

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

    private var expandType: ExpandState = .closed

    public init(viewController: UIViewController) {
        super.init(frame: .zero)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: .zero)
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
        titleLabel.text = UserDefaults.standard.OtpInfo ? Strings.added : Strings.add
        descriptionLabel.text = Strings.description
        potentialValueLabel.text = Strings.potentialValue
        potentialValueLoading.hidesWhenStopped = true

        detailedDescriptionLabel.setLinkText(
            orgText: Strings.detailedDescription,
            linkText: Strings.learnMoreLinkText,
            link: Strings.extraLink,
            tapHandler: onTapLearnMore)
        detailedDescriptionLabel.isHidden = true
        margin.isHidden = true
        extraInfoLabel.setLinkText(
            orgText: Strings.extraInfo,
            linkText: Strings.extraLinkText,
            link: Strings.extraLink,
            tapHandler: onTapExtraInfoLink)

        addToAirRobeSwitch.isOn = UserDefaults.standard.OtpInfo
        addToAirRobeSwitch.onTintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)
        addToAirRobeSwitch.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

        arrowImageView.image = arrowImageView.image?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)
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
        UserDefaults.standard.OtpInfo = sender.isOn
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
#endif

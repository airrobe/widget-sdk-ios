//
//  EnhancedLearnMoreAlertViewController.swift
//  
//
//  Created by King on 9/20/22.
//

import Foundation
import UIKit

final class EnhancedLearnMoreAlertViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var howItWorksLabel: UILabel!
    @IBOutlet weak var howItWorksTitleDivider: UIView!
    @IBOutlet weak var step1TitleLabel: UILabel!
    @IBOutlet weak var step2TitleLabel: UILabel!
    @IBOutlet weak var step2DescriptionLabel: UILabel!
    @IBOutlet weak var step3TitleLabel: UILabel!
    @IBOutlet weak var step3DescriptionLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var addDescriptionLabel: UILabel!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var optSwitch: AirRobeSwitch!
    @IBOutlet weak var learnMoreLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var closeLabel: AirRobeHyperlinkLabel!

    var viewType: EnhancedOptInView.ViewType = .optIn

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = AirRobeEnhancedStrings.learnMoreTitle.uppercased()
        titleLabel.textColor = AirRobeTextColor
        descriptionLabel.text = AirRobeEnhancedStrings.learnMoreStep2Description
        descriptionLabel.textColor = AirRobeTextColor
        howItWorksLabel.text = AirRobeEnhancedStrings.learnHowItWorksTitle
        howItWorksLabel.textColor = AirRobeTextColor
        howItWorksTitleDivider.backgroundColor = AirRobeSeparatorColor
        step1TitleLabel.text = AirRobeEnhancedStrings.learnMoreStep1Title.uppercased()
        step1TitleLabel.textColor = AirRobeTextColor
        step2TitleLabel.text = AirRobeEnhancedStrings.learnMoreStep2Title.uppercased()
        step2TitleLabel.textColor = AirRobeTextColor
        step2DescriptionLabel.text = AirRobeEnhancedStrings.learnMoreStep2Description
        step2DescriptionLabel.textColor = AirRobeTextColor
        step3TitleLabel.text = AirRobeEnhancedStrings.learnMoreStep3Title.uppercased()
        step3TitleLabel.textColor = AirRobeTextColor
        step3DescriptionLabel.text = AirRobeEnhancedStrings.learnMoreStep3Description
        step3DescriptionLabel.textColor = AirRobeTextColor

        learnMoreLabel.hyperlinkAttributes = [.foregroundColor: AirRobeLinkTextColor]
        guard let learnMoreFindMoreLink = URL(string: AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.data.shop.popupFindOutMoreUrl ?? "") else {
            #if DEBUG
            print("Popup find out more url is not valid.")
            #endif
            return
        }
        learnMoreLabel.setLinkText(
            orgText: AirRobeEnhancedStrings.learnMoreText,
            linkText: AirRobeEnhancedStrings.learnMoreText,
            link: learnMoreFindMoreLink,
            tapHandler: onTapLearnMoreLink)

        optSwitch.thumbOnImage = UIImage(named: "check", in: .module, with: nil)
        optSwitch.thumbOnTintColor = .white
        optSwitch.onTintColor = .black
        optSwitch.thumbOffImage = UIImage(named: "arrow", in: .module, with: nil)
        optSwitch.thumbOffTintColor = .black
        optSwitch.offTintColor = .white
        optSwitch.isOn = UserDefaults.standard.OptedIn

        optSwitch.tintColor = AirRobeSwitchColor
        addLabel.text = optSwitch.isOn ? AirRobeEnhancedStrings.add.uppercased() : AirRobeEnhancedStrings.added.uppercased()
        addLabel.textColor = AirRobeTextColor
        addDescriptionLabel.text = AirRobeEnhancedStrings.description
        addDescriptionLabel.textColor = AirRobeTextColor

        closeLabel.hyperlinkAttributes = [.foregroundColor: AirRobeLinkTextColor]
        closeLabel.setLinkText(
            orgText: AirRobeEnhancedStrings.learnMoreClose.uppercased(),
            linkText: AirRobeEnhancedStrings.learnMoreClose.uppercased(),
            link: AirRobeEnhancedStrings.learnMoreLinkForPurpose,
            tapHandler: onTapCloseText)

        mainStackView.setCustomSpacing(5, after: howItWorksLabel)
        mainStackView.setCustomSpacing(32, after: descriptionLabel)
        mainStackView.setCustomSpacing(24, after: howItWorksTitleDivider)
        mainView.addShadow()
        switchContainerView.backgroundColor = UIColor(colorCode: "F1F1F1")

        let tapOnCloseImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tapOnCloseImageGestureRecognizer)

        let outTap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        outsideView.addGestureRecognizer(outTap)
    }

    private func onTapLearnMoreLink(_ url: URL) {
        AirRobeUtils.openUrl(url)
    }

    private func onTapCloseText(_ url: URL) {
        dismissController()
    }

    @IBAction func onToggleOptSwitch(_ sender: AirRobeSwitch) {
        UserDefaults.standard.OptedIn = sender.isOn
        if sender.isOn {
            if viewType == .optIn {
                AirRobeUtils.telemetryEvent(eventName: EventName.optIn.rawValue, pageName: PageName.product.rawValue)
            } else {
                AirRobeUtils.telemetryEvent(eventName: EventName.optIn.rawValue, pageName: PageName.cart.rawValue)
            }
        } else {
            if viewType == .optIn {
                AirRobeUtils.telemetryEvent(eventName: EventName.optOut.rawValue, pageName: PageName.product.rawValue)
            } else {
                AirRobeUtils.telemetryEvent(eventName: EventName.optOut.rawValue, pageName: PageName.cart.rawValue)
            }
        }
    }

    @objc func dismissController() {
        dismiss(animated: true)
        if viewType == .optIn {
            AirRobeUtils.dispatchEvent(eventName: EventName.popupClose.rawValue, pageName: PageName.product.rawValue)
        } else {
            AirRobeUtils.dispatchEvent(eventName: EventName.popupClose.rawValue, pageName: PageName.cart.rawValue)
        }
    }
}

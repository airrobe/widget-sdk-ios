//
//  AirRobeLearnMoreAlertViewController.swift
//  
//
//  Created by King on 11/30/21.
//

import Foundation
import UIKit

final class AirRobeLearnMoreAlertViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var step1View: UIView!
    @IBOutlet weak var step1TitleLabel: UILabel!
    @IBOutlet weak var step1DescriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var step2View: UIView!
    @IBOutlet weak var step2TitleLabel: UILabel!
    @IBOutlet weak var step2DescriptionLabel: UILabel!
    @IBOutlet weak var readyLabel: UILabel!
    @IBOutlet weak var toggleOnLabel: UILabel!
    @IBOutlet weak var switchContainerView: UIView!
    @IBOutlet weak var optSwitch: UISwitch!
    @IBOutlet weak var findMoreLabel: AirRobeHyperlinkLabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var separator3: UIView!

    var viewType: AirRobeOptInView.ViewType = .optIn

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = AirRobeStrings.learnMoreTitle
        titleLabel.textColor = AirRobeTextColor
        step1TitleLabel.text = AirRobeStrings.learnMoreStep1Title
        step1TitleLabel.textColor = AirRobeTextColor
        step1DescriptionLabel.text = AirRobeStrings.learnMoreStep1Description
        step1DescriptionLabel.textColor = AirRobeTextColor
        step2TitleLabel.text = AirRobeStrings.learnMoreStep2Title
        step2TitleLabel.textColor = AirRobeTextColor
        step2DescriptionLabel.text = AirRobeStrings.learnMoreStep2Description
        step2DescriptionLabel.textColor = AirRobeTextColor
        questionLabel.text = AirRobeStrings.learnMoreQuestion
        questionLabel.textColor = AirRobeTextColor
        answerLabel.text = AirRobeStrings.learnMoreAnswer
        answerLabel.textColor = AirRobeTextColor
        readyLabel.text = AirRobeStrings.learnMoreReady
        readyLabel.textColor = AirRobeTextColor
        toggleOnLabel.text = AirRobeStrings.learnMoreToggleOn
        toggleOnLabel.textColor = AirRobeTextColor
        findMoreLabel.hyperlinkAttributes = [.foregroundColor: AirRobeLinkTextColor]
        guard let learnMoreFindMoreLink = URL(string: AirRobeShoppingDataModelInstance.shared.shoppingDataModel?.data.shop.popupFindOutMoreUrl ?? "") else {
            #if DEBUG
            print("Popup find out more url is not valid.")
            #endif
            return
        }
        findMoreLabel.setLinkText(
            orgText: AirRobeStrings.learnMoreFindMoreText,
            linkText: AirRobeStrings.learnMoreFindMoreText,
            link: learnMoreFindMoreLink,
            tapHandler: onTapFindMoreLink)
        optSwitch.isOn = UserDefaults.standard.OptedIn
        optSwitch.onTintColor = AirRobeSwitchColor
        optSwitch.tintColor = AirRobeSwitchColor

        mainView.addShadow()
        step1View.addBorder(color: AirRobeBorderColor.cgColor)
        step1View.addShadow()
        step2View.addBorder(color: AirRobeBorderColor.cgColor)
        step2View.addShadow()
        switchContainerView.addBorder(color: AirRobeBorderColor.cgColor, cornerRadius: 22)
        separator1.backgroundColor = AirRobeSeparatorColor
        separator2.backgroundColor = AirRobeSeparatorColor
        separator3.backgroundColor = AirRobeSeparatorColor

        let outTap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        outsideView.addGestureRecognizer(outTap)
    }

    private func onTapFindMoreLink(_ url: URL) {
        AirRobeUtils.openUrl(url)
    }

    @IBAction func onToggleOptSwitch(_ sender: UISwitch) {
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

    @IBAction func onTapClose(_ sender: Any) {
        dismiss(animated: true)
        if viewType == .optIn {
            AirRobeUtils.dispatchEvent(eventName: EventName.popupClose.rawValue, pageName: PageName.product.rawValue)
        } else {
            AirRobeUtils.dispatchEvent(eventName: EventName.popupClose.rawValue, pageName: PageName.cart.rawValue)
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

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

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = AirRobeStrings.learnMoreTitle
        step1TitleLabel.text = AirRobeStrings.learnMoreStep1Title
        step1DescriptionLabel.text = AirRobeStrings.learnMoreStep1Description
        step2TitleLabel.text = AirRobeStrings.learnMoreStep2Title
        step2DescriptionLabel.text = AirRobeStrings.learnMoreStep2Description
        questionLabel.text = AirRobeStrings.learnMoreQuestion
        answerLabel.text = AirRobeStrings.learnMoreAnswer
        readyLabel.text = AirRobeStrings.learnMoreReady
        toggleOnLabel.text = AirRobeStrings.learnMoreToggleOn
        findMoreLabel.setLinkText(
            orgText: AirRobeStrings.learnMoreFindMoreText,
            linkText: AirRobeStrings.learnMoreFindMoreText,
            link: AirRobeStrings.learnMoreFindMoreLink,
            tapHandler: onTapFindMoreLink)
        optSwitch.isOn = UserDefaults.standard.OptedIn
        optSwitch.onTintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)
        optSwitch.tintColor = UIColor(colorCode: UserDefaults.standard.BaseColor)

        mainView.addShadow()
        step1View.addBorder()
        step1View.addShadow()
        step2View.addBorder()
        step2View.addShadow()
        switchContainerView.addBorder(cornerRadius: 22)

        let outTap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        outsideView.addGestureRecognizer(outTap)
    }

    private func onTapFindMoreLink(_ url: URL) {
        AirRobeUtils.openUrl(url)
    }

    @IBAction func onToggleOptSwitch(_ sender: UISwitch) {
        UserDefaults.standard.OptedIn = sender.isOn
    }

    @IBAction func onTapClose(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func dismissController() {
        dismiss(animated: true)
    }
}

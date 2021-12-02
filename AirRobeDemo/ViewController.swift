//
//  ViewController.swift
//  AirRobeDemo
//
//  Created by King on 11/22/21.
//

import UIKit
import AirRobeWidget

final class ViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    private var airRobeOtpIn: AirRobeOtpIn = AirRobeOtpIn()
    private var airRobeOrderConfirmation: AirRobeOrderConfirmation = AirRobeOrderConfirmation()
    override func viewDidLoad() {
        super.viewDidLoad()

        airRobeOtpIn.initialize(
            viewController: self,
            brand: "",
            material: "",
            category: "Accessories",
            priceCents: "120",
            originalFullPriceCents: "120",
            rrpCents: "100",
            currency: "AUD",
            locale: "en-AU")
//        widgetOnMultiOtp.initialize(items: ["Accessories/Jewellery", "Accessories/Jewellery"])
        stackView.addArrangedSubview(airRobeOtpIn)

        airRobeOrderConfirmation.initialize()
        stackView.addArrangedSubview(airRobeOrderConfirmation)
        /// In order to clear cache for Otp Info
        /// AirRobeWidget.current.clearCache()
    }
}


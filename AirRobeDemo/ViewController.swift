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
    private var airRobeMultiOtpIn: AirRobeMultiOtpIn = AirRobeMultiOtpIn()
    private var airRobeConfirmation: AirRobeConfirmation = AirRobeConfirmation()
    override func viewDidLoad() {
        super.viewDidLoad()

        airRobeOtpIn.initialize(
            brand: "",
            material: "",
            category: "Accessories",
            priceCents: "120",
            originalFullPriceCents: "120",
            rrpCents: "100",
            currency: "AUD",
            locale: "en-AU")
        stackView.addArrangedSubview(airRobeOtpIn)

        airRobeMultiOtpIn.initialize(
            items: ["Accessories", "Accessories/Beauty", "Accessories/Bags/Leather bags/Weekender/Handbags", "Accessories/Bags/Clutches/Bum Bags"]
        )
        stackView.addArrangedSubview(airRobeMultiOtpIn)

        airRobeConfirmation.initialize(
            orderId: "123456"
        )
        stackView.addArrangedSubview(airRobeConfirmation)
        /// In order to clear cache for Otp Info
        /// AirRobeWidget.current.clearCache()
    }
}


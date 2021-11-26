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
    private var widgetOnShop: WidgetOnShop = WidgetOnShop()
    override func viewDidLoad() {
        super.viewDidLoad()

        widgetOnShop.initialize(
            brand: "",
            material: "",
            category: "Accessories/Jewellery",
            priceCents: "120",
            originalFullPriceCents: "120",
            rrpCents: "100",
            currency: "AUD",
            locale: "en-AU")
        stackView.addArrangedSubview(widgetOnShop)
    }
}


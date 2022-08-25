//
//  ConfirmationViewController.swift
//  AirRobeDemo
//
//  Created by King on 11/22/21.
//

import UIKit
import AirRobeWidget

final class ConfirmationViewController: UIViewController {
    @IBOutlet weak var thankyouLabel: UILabel!

    private lazy var airRobeConfirmation: AirRobeConfirmation = AirRobeConfirmation()
    var orderId: String = ""
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        airRobeConfirmation.initialize(
            orderId: orderId,
            email: email,
            orderSubtotalCents: 10000
        )
        // This part is how you can configure the colors of the widget
//        airRobeConfirmation.borderColor = .red
//        airRobeConfirmation.textColor = .blue
//        airRobeConfirmation.buttonBorderColor = .black
//        airRobeConfirmation.buttonTextColor = .black
        view.addSubview(airRobeConfirmation)
        NSLayoutConstraint.activate([
            airRobeConfirmation.topAnchor.constraint(equalTo: thankyouLabel.bottomAnchor, constant: 20),
            airRobeConfirmation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            airRobeConfirmation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

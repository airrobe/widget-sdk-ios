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

    var airRobeConfirmation: AirRobeConfirmation = AirRobeConfirmation()
    var orderId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        airRobeConfirmation.initialize(
            orderId: orderId
        )
        view.addSubview(airRobeConfirmation)
        airRobeConfirmation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            airRobeConfirmation.topAnchor.constraint(equalTo: thankyouLabel.bottomAnchor, constant: 20),
            airRobeConfirmation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            airRobeConfirmation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}


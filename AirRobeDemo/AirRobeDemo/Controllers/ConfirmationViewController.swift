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
    @IBOutlet weak var airRobeConfirmation: AirRobeConfirmation!
    
    var orderId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        airRobeConfirmation.initialize(
            orderId: orderId
        )
    }
}


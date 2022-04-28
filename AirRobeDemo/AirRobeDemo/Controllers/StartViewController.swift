//
//  StartViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/21/22.
//

import Foundation
import UIKit

final class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }

    @IBAction func onTapGetStarted(_ sender: Any) {
        let vc = BrandViewController()
        vc.title = "airrobe"
        navigationController?.setViewControllers([vc], animated: true)
    }
}

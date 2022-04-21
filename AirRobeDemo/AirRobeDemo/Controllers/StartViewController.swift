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
        appearance.backgroundColor = .lightGray
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }

    @IBAction func onTapGetStarted(_ sender: Any) {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

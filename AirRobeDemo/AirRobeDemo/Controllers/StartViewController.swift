//
//  StartViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/21/22.
//

import Foundation
import UIKit

final class StartViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let scaledLogoTransform = logoImageView.transform.scaledBy(x: 1.25, y: 1.25)

        UIView.animate(withDuration: 2, animations: {
            self.logoImageView.transform = scaledLogoTransform
            self.logoImageView.alpha = 1
        }) { isCompleted in
            let vc = BrandViewController()
            vc.title = "airrobe"
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}

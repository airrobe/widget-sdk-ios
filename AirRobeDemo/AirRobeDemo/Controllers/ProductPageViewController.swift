//
//  ProductPageViewController.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import UIKit
import AirRobeWidget

final class ProductPageViewController: UIViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    private lazy var airRobeOptIn: AirRobeOptIn = AirRobeOptIn()
    private(set) lazy var viewModel = ProductPageViewModel()

    var cartButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let cellViewModel = viewModel.cellViewModel {
            itemImageView.image = UIImage(named: cellViewModel.image)
            categoryLabel.text = cellViewModel.category
            titleLabel.text = cellViewModel.title
            subTitleLabel.text = cellViewModel.subTitle
            priceLabel.text = cellViewModel.price

            // Initialize airRobeOptIn view
            airRobeOptIn.initialize(
                category: cellViewModel.category,
                priceCents: Double(String(cellViewModel.price.replacingOccurrences(of: "$", with: ""))) ?? 0.0
            )

            // This part is how you can configure the colors of the widget
//            airRobeOptIn.borderColor = .red
//            airRobeOptIn.linkTextColor = .yellow
//            airRobeOptIn.textColor = .blue
//            airRobeOptIn.arrowColor = .black
//            airRobeOptIn.switchColor = .black
            stackView.addArrangedSubview(airRobeOptIn)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        addCartButton()
    }

    private func addCartButton() {
        let customButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        customButton.setImage(UIImage(named:"cart"), for: .normal)
        customButton.addTarget(self, action: #selector(onTapCart), for: .touchUpInside)
        cartButton = UIBarButtonItem(customView: customButton)
        cartButton?.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cartButton?.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cartButton?.addBadge(number: UserDefaults.standard.cartItems.count)
        navigationItem.rightBarButtonItem = cartButton
    }

    @objc func onTapCart(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartPageViewController") as! CartPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapAddToBag(_ sender: Any) {
        guard let cellViewModel = viewModel.cellViewModel else {
            return
        }
        var cartItems = UserDefaults.standard.cartItems
        cartItems.append(cellViewModel)
        UserDefaults.standard.cartItems = cartItems
        navigationItem.rightBarButtonItem?.updateBadge(number: cartItems.count)
    }
}

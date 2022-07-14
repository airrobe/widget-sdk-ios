//
//  CartPageViewController.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import UIKit
import AirRobeWidget

final class CartPageViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var emailTextField: UITextField!

    private var cartItemViews: [CartItemView] = []
    private lazy var airRobeMultiOptIn: AirRobeMultiOptIn = AirRobeMultiOptIn()

    override func viewDidLoad() {
        super.viewDidLoad()
        initCart()
        initMultiOptIn()

        emailTextField.delegate = self
    }

    private func initCart() {
        let cartItems = UserDefaults.standard.cartItems
        cartItems.enumerated().forEach { (index, item) in
            guard
                let nib = Bundle.main.loadNibNamed("CartItemView", owner: self, options: nil),
                let cartItemView = nib.first as? CartItemView else {
                    fatalError("failed to load CartItemView")
            }
            cartItemView.heightAnchor.constraint(equalToConstant: 250).isActive = true
            cartItemView.titleLabel.text = item.title
            cartItemView.subtitleLabel.text = item.subTitle
            cartItemView.priceLabel.text = item.price
            cartItemView.itemImageView.image = UIImage(named: item.image)
            cartItemView.removeButton.tag = index
            cartItemView.removeButton.addTarget(self, action: #selector(onTapRemoveItem), for: .touchUpInside)
            cartItemViews.append(cartItemView)
            stackView.insertArrangedSubview(cartItemView, at: 0)
        }
    }

    private func initMultiOptIn() {
        airRobeMultiOptIn.removeFromSuperview()
        let categories = UserDefaults.standard.cartItems.map { $0.category }
        airRobeMultiOptIn.initialize(
            items: categories
        )
        // This part is how you can configure the colors of the widget
//        airRobeMultiOptIn.borderColor = .red
//        airRobeMultiOptIn.linkTextColor = .yellow
//        airRobeMultiOptIn.textColor = .blue
//        airRobeMultiOptIn.arrowColor = .black
//        airRobeMultiOptIn.switchColor = .black
        if let index = stackView.arrangedSubviews.firstIndex(of: margin) {
            stackView.insertArrangedSubview(airRobeMultiOptIn, at: index)
        }
    }

    private func resetCart() {
        cartItemViews.forEach {
            $0.removeButton.removeTarget(self, action: #selector(onTapRemoveItem), for: .touchUpInside)
            $0.removeFromSuperview()
        }
        cartItemViews = []
        initCart()
        initMultiOptIn()
    }

    @objc func onTapRemoveItem(_ sender: UIButton) {
        var cartItems = UserDefaults.standard.cartItems
        cartItems.remove(at: sender.tag)
        UserDefaults.standard.cartItems = cartItems
        resetCart()
    }

    @IBAction func onTapPlaceOrder(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        vc.orderId = "random_order_id"
        guard let email = emailTextField.text, Utils.isValidEmail(email: email) else {
            Utils.showAlert(title: "AirRobeDemo", message: "Email is invalid.", vc: self)
            return
        }
        vc.email = email
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}

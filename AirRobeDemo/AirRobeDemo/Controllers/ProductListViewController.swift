//
//  ProductListViewController.swift
//  AirRobeDemo
//
//  Created by King on 12/7/21.
//

import UIKit

final class ProductListViewController: UIViewController {
    var cartButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func viewWillAppear(_ animated: Bool) {
        addCartButton()
    }

    @objc func onTapCart(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartPageViewController") as! CartPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapBag1(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 0)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapBag2(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 1)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapBag3(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 2)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapBag4(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 3)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapGift1(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 4)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapGift2(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 5)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapGift3(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 6)
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onTapGift4(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: 7)
        navigationController?.pushViewController(vc, animated: true)
    }
}

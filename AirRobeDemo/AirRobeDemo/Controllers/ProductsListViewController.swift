//
//  ProductsListViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/28/22.
//

import UIKit

final class ProductsListViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(UINib.init(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductItemCollectionViewCell")
        return collectionView
    }()
    private var cartButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 8
            flowLayout.minimumInteritemSpacing = 4
        }
        view.addSubview(collectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        addCartButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartPageViewController") as! CartPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onTapProduct(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductPageViewController") as! ProductPageViewController
        vc.title = products[sender.tag].title
        vc.viewModel.cellViewModel = vc.viewModel.initCell(at: sender.tag)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductsListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemCollectionViewCell", for: indexPath) as? ProductItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.productImageView.image = UIImage(named: products[indexPath.row].image)
        cell.productTitleLabel.text = products[indexPath.row].title
        cell.productSubTitleLabel.text = products[indexPath.row].subTitle
        cell.productButton.tag = indexPath.row
        cell.productButton.addTarget(self, action: #selector(onTapProduct), for: .touchUpInside)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 10, height: 300)
    }
}

//
//  SubCategoryViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/27/22.
//

import UIKit

final class SubCategoryViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SubCategoryTableViewCell.self, forCellReuseIdentifier: "SubCategoryTableViewCell")
        return tableView
    }()
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "demoLightGray")
        return view
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let categoryImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    var selectedCategory: CategoryModel?

    var cartButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        addViews()
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartPageViewController") as! CartPageViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    func addViews() {
        guard let selectedCategory = selectedCategory else {
            return
        }
        categoryLabel.text = selectedCategory.category
        categoryImage.image = selectedCategory.image
        headerContainer.addSubview(categoryLabel)
        headerContainer.addSubview(categoryImage)
        view.addSubview(headerContainer)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            categoryLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            categoryImage.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 20),
            categoryImage.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            categoryImage.widthAnchor.constraint(equalToConstant: 100),
            categoryImage.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            categoryImage.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerContainer.heightAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func onTapCategory(_ sender: UIButton) {
        let vc = ProductsListViewController()
        vc.title = subCategories[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryTableViewCell = Bundle.main.loadNibNamed("SubCategoryTableViewCell", owner: self, options: nil)?.first as? SubCategoryTableViewCell else {
            return UITableViewCell()
        }
        categoryTableViewCell.subCategoryButton.addTarget(self, action: #selector(onTapCategory), for: .touchUpInside)
        categoryTableViewCell.subCategoryButton.tag = indexPath.row
        categoryTableViewCell.subCategoryLabel.text = subCategories[indexPath.row]
        return categoryTableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

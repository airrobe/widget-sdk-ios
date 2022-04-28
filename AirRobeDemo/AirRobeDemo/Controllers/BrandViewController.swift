//
//  BrandViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/27/22.
//

import UIKit

final class BrandViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.sectionHeaderTopPadding = 10
    }

    @objc func onTapCategory(_ button: UIButton) {
        let vc = CategoryViewController()
        vc.title = brands[button.tag].category
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BrandViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryTableViewCell = Bundle.main.loadNibNamed("CategoryTableViewCell", owner: self, options: nil)?.first as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        categoryTableViewCell.containerView.backgroundColor = UIColor(named: "demoLightGray")
        categoryTableViewCell.categoryButton.addTarget(self, action: #selector(onTapCategory), for: .touchUpInside)
        categoryTableViewCell.categoryButton.tag = indexPath.row

        categoryTableViewCell.categoryLabel.text = brands[indexPath.row].category
        categoryTableViewCell.categoryImageView.image = brands[indexPath.row].image

        return categoryTableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//
//  ProductPageTableViewController.swift
//  AirRobeDemo
//
//  Created by King on 2/10/22.
//

import Foundation
import UIKit
import AirRobeWidget

class ProductPageTableViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AirRobeOptInTableViewCell.nib, forCellReuseIdentifier: AirRobeOptInTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ProductPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AirRobeOptInTableViewCell.reuseIdentifier, for: indexPath) as? AirRobeOptInTableViewCell else {
            return UITableViewCell()
        }
        cell.initialize(
            category: "Accessories",
            priceCents: 120
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

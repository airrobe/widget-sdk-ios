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
        tableView.register(ProductPageTableViewCell.self, forCellReuseIdentifier: ProductPageTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ProductPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPageTableViewCell.identifier, for: indexPath) as? ProductPageTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.initialize(type: .optIn)
        } else if indexPath.row == 1 {
            cell.initialize(type: .multiOptIn)
        } else if indexPath.row == 2 {
            cell.initialize(type: .confirmation)
        } else {
            cell.initialize(type: .optIn)
        }
        return cell
    }
}

enum ViewType {
    case optIn
    case multiOptIn
    case confirmation
}

class ProductPageTableViewCell: UITableViewCell {
    static let identifier = "ProductPageTableViewCell"
    private lazy var airRobeOptIn: AirRobeOptIn = AirRobeOptIn()
    private lazy var airRobeMultiOptIn: AirRobeMultiOptIn = AirRobeMultiOptIn()
    private lazy var airRobeConfirmation: AirRobeConfirmation = AirRobeConfirmation()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize(type: ViewType) {
        switch type {
        case .optIn:
            airRobeOptIn.initialize(
                category: "Accessories",
                priceCents: 120
            )
            contentView.addSubview(airRobeOptIn)
            NSLayoutConstraint.activate([
                airRobeOptIn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                airRobeOptIn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                airRobeOptIn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                airRobeOptIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        case .multiOptIn:
            airRobeMultiOptIn.initialize(
                items: ["Accessories", "Accessories"]
            )
            contentView.addSubview(airRobeMultiOptIn)
            NSLayoutConstraint.activate([
                airRobeMultiOptIn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                airRobeMultiOptIn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                airRobeMultiOptIn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                airRobeMultiOptIn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        case .confirmation:
            airRobeConfirmation.initialize(
                orderId: "random_id", email: "raj@airrobe.com"
            )
            contentView.addSubview(airRobeConfirmation)
            NSLayoutConstraint.activate([
                airRobeConfirmation.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                airRobeConfirmation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                airRobeConfirmation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                airRobeConfirmation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        }
    }
}

//
//  ProductPageTableViewCell.swift
//  AirRobeDemo
//
//  Created by King on 2/10/22.
//

import UIKit
import AirRobeWidget

class ProductPageTableViewCell: UITableViewCell {
    static let identifier = "ProductPageTableViewCell"
    private lazy var airRobeOptIn: AirRobeOptIn = AirRobeOptIn()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

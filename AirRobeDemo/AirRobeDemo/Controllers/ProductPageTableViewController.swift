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
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(LabelTableViewCell.self, forCellReuseIdentifier: LabelTableViewCell.identifier)
        tableView.register(ProductPageTableViewCell.self, forCellReuseIdentifier: ProductPageTableViewCell.identifier)
        return tableView
    }()
    private var dataCount: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableView Demo"
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    @objc func onTapAction(_ button: UIButton) {
        if dataCount == 1 {
            dataCount = 10
            button.setTitle("Make row count to 1", for: .normal)
        } else {
            dataCount = 1
            button.setTitle("Make row count to 10", for: .normal)
        }
        tableView.reloadData()
    }
}

extension ProductPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            buttonCell.button.addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
            return buttonCell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPageTableViewCell.identifier, for: indexPath) as? ProductPageTableViewCell else {
                return UITableViewCell()
            }
            cell.initialize(type: .optIn)
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPageTableViewCell.identifier, for: indexPath) as? ProductPageTableViewCell else {
                return UITableViewCell()
            }
            cell.initialize(type: .multiOptIn)
            return cell
        } else if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPageTableViewCell.identifier, for: indexPath) as? ProductPageTableViewCell else {
                return UITableViewCell()
            }
            cell.initialize(type: .confirmation)
            return cell
        } else {
            guard let labelCell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell else {
                return UITableViewCell()
            }
            return labelCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 {
            return UITableView.automaticDimension
        } else {
            return 200
        }
    }
}

enum ViewType {
    case optIn
    case multiOptIn
    case confirmation
}

private final class ProductPageTableViewCell: UITableViewCell {
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

private final class LabelTableViewCell: UITableViewCell {
    static let identifier = "LabelTableViewCell"
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        contentView.addSubview(label)
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

private final class ButtonTableViewCell: UITableViewCell {
    static let identifier = "ButtonTableViewCell"
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Make row count to 1", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        contentView.addSubview(button)
        button.frame = contentView.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

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
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        return tableView
    }()

    var cartButton: UIBarButtonItem?

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.sectionHeaderTopPadding = 10
    }

    @objc func onTapCategory(_ sender: UIButton) {
        let vc = CategoryViewController()
        vc.title = brands[sender.tag].category
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onTapDemoForTable(_ button: UIButton) {
        let vc = ProductPageTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BrandViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == brands.count {
            guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
                return UITableViewCell()
            }
            buttonCell.button.addTarget(self, action: #selector(onTapDemoForTable), for: .touchUpInside)
            return buttonCell
        }
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
        if indexPath.row == brands.count {
            return 30
        }
        return 120
    }
}

private final class ButtonTableViewCell: UITableViewCell {
    static let identifier = "ButtonTableViewCell"
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Or Demo For TableView Loadout", for: .normal)
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

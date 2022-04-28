//
//  CateogryViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/20/22.
//

import UIKit

final class CategoryViewController: UIViewController {
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

    @objc func onTapCategory(_ sender: UIButton) {
        let vc = SubCategoryViewController()
        vc.title = categories[sender.tag].category
        vc.selectedCategory = categories[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryTableViewCell = Bundle.main.loadNibNamed("CategoryTableViewCell", owner: self, options: nil)?.first as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        categoryTableViewCell.containerView.backgroundColor = UIColor(named: "demoLightGray")
        categoryTableViewCell.categoryButton.addTarget(self, action: #selector(onTapCategory), for: .touchUpInside)
        categoryTableViewCell.categoryButton.tag = indexPath.row

        categoryTableViewCell.categoryLabel.text = categories[indexPath.row].category
        categoryTableViewCell.categoryImageView.image = categories[indexPath.row].image

        return categoryTableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

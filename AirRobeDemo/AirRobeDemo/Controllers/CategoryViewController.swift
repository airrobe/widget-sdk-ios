//
//  CateogryViewController.swift
//  AirRobeDemo
//
//  Created by King on 4/20/22.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.sectionHeaderTopPadding = 10
    }

    @objc func onTapCategory(_ button: UIButton) {
        
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
        categoryTableViewCell.containerView.layer.cornerRadius = 10
        categoryTableViewCell.containerView.backgroundColor = .lightGray
        categoryTableViewCell.containerView.addShadow()
        categoryTableViewCell.categoryLabel.text = categories[indexPath.row].category
        categoryTableViewCell.categoryButton.addTarget(self, action: #selector(onTapCategory), for: .touchUpInside)
        return categoryTableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

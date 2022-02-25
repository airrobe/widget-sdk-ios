//
//  UIView+Extensions+TableView.swift
//  
//
//  Created by King on 2/21/22.
//
import UIKit

extension UIView {
    var tableViewCell: UITableViewCell? {
        var parent = superview

        while parent != nil {
            if let tv = parent as? UITableViewCell { return tv }
            parent = parent?.superview
        }

        return nil
    }

    var tableView: UITableView? {
        var parent = superview

        while parent != nil {
            if let tv = parent as? UITableView { return tv }
            parent = parent?.superview
        }

        return nil
    }
}

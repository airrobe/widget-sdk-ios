//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    static let OptedInKey = "OptedInKey"
    @objc var OptedIn: Bool {
        get { return bool(forKey: UserDefaults.OptedInKey) }
        set { set(newValue, forKey: UserDefaults.OptedInKey) }
    }

    static let OrderOptedInKey = "OrderOptedInKey"
    var OrderOptedIn: Bool {
        get { return bool(forKey: UserDefaults.OrderOptedInKey) }
        set { set(newValue, forKey: UserDefaults.OrderOptedInKey) }
    }

    static let BaseColorKey = "BaseColorKey"
    var BaseColor: String {
        get { return string(forKey: UserDefaults.BaseColorKey) ?? "" }
        set { set(newValue, forKey: UserDefaults.BaseColorKey) }
    }
}

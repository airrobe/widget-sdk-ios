//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    static let OptInfoKey = "OptInfoKey"
    @objc var OptInfo: Bool {
        get { return bool(forKey: UserDefaults.OptInfoKey) }
        set { set(newValue, forKey: UserDefaults.OptInfoKey) }
    }

    static let EligibilityKey = "EligibilityKey"
    @objc var Eligibility: Bool {
        get { return bool(forKey: UserDefaults.EligibilityKey) }
        set { set(newValue, forKey: UserDefaults.EligibilityKey) }
    }

    static let BaseColorKey = "BaseColorKey"
    var BaseColor: String {
        get { return string(forKey: UserDefaults.BaseColorKey) ?? "" }
        set { set(newValue, forKey: UserDefaults.BaseColorKey) }
    }
}

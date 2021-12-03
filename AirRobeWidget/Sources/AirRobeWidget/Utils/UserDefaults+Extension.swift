//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    static let AppIdKey = "AppIdKey"
    @objc var AppId: String {
        get { return string(forKey: UserDefaults.AppIdKey) ?? "" }
        set { set(newValue, forKey: UserDefaults.AppIdKey) }
    }

    static let OtpInfoKey = "OtpInfoKey"
    @objc var OtpInfo: Bool {
        get { return bool(forKey: UserDefaults.OtpInfoKey) }
        set { set(newValue, forKey: UserDefaults.OtpInfoKey) }
    }

    static let EligibilityKey = "EligibilityKey"
    @objc var Eligibility: Bool {
        get { return bool(forKey: UserDefaults.EligibilityKey) }
        set { set(newValue, forKey: UserDefaults.EligibilityKey) }
    }
}

//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    static let OtpInfoKey = "OtpInfoKey"
    var OtpInfo: Bool {
        get { return bool(forKey: UserDefaults.OtpInfoKey) }
        set { set(newValue, forKey: UserDefaults.OtpInfoKey) }
    }
}

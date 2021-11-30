//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    static let categoryMappingInfoKey = "AirRobeWidgetCategoryMappingInfo"
    var categoryMappingInfo: CategoryModel? {
        get {
            guard let savedData = object(forKey: UserDefaults.categoryMappingInfoKey) as? Data else {
                return nil
            }
            guard let loadedData = try? JSONDecoder().decode(CategoryModel.self, from: savedData) else {
                return nil
            }
            return loadedData
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else {
               set(nil, forKey: UserDefaults.categoryMappingInfoKey)
               return
            }
            set(encoded, forKey: UserDefaults.categoryMappingInfoKey)
        }
    }

    static let shouldLoadWidgetKey = "shouldLoadWidgetKey"
    @objc var shouldLoadWidget: Bool {
        get { return bool(forKey: UserDefaults.shouldLoadWidgetKey) }
        set { set(newValue, forKey: UserDefaults.shouldLoadWidgetKey) }
    }

    static let OtpInfoKey = "OtpInfoKey"
    var OtpInfo: Bool {
        get { return bool(forKey: UserDefaults.OtpInfoKey) }
        set { set(newValue, forKey: UserDefaults.OtpInfoKey) }
    }
}

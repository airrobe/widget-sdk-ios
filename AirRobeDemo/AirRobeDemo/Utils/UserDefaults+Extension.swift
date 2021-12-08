//
//  UserDefaults+Extension.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import Foundation

extension UserDefaults {
    static let cartItemsKey = "cartItemsKey"
    var cartItems: ItemModels {
        get {
            guard let savedData = object(forKey: UserDefaults.cartItemsKey) as? Data else {
                return []
            }
            guard let loadedData = try? JSONDecoder().decode(ItemModels.self, from: savedData) else {
                return []
            }
            return loadedData
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: UserDefaults.cartItemsKey)
            }
        }
    }
}

//
//  UserDefaults+Extension.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

extension UserDefaults {
    enum Key {
        static let OptedInKey = "OptedInKey"
        static let OrderOptedInKey = "OrderOptedInKey"
        static let SplitTestVariantKey = "SplitTestVariantKey"
    }

    @objc var OptedIn: Bool {
        get { return bool(forKey: Key.OptedInKey) }
        set { set(newValue, forKey: Key.OptedInKey) }
    }

    var OrderOptedIn: Bool {
        get { return bool(forKey: Key.OrderOptedInKey) }
        set { set(newValue, forKey: Key.OrderOptedInKey) }
    }

    var SplitTestVariant: AirRobeWidgetVariant? {
        get { return getCodable(Key.SplitTestVariantKey) }
        set { setCodable(newValue, forKey: Key.SplitTestVariantKey) }
    }
}

extension UserDefaults {
    func getCodable<T: Codable>(_ key: String) -> T? {
        if let savedData = object(forKey: key) as? Data {
            do {
                let loadedData = try JSONDecoder().decode(T.self, from: savedData)
                return loadedData
            } catch {
                print(String(describing: error))
                return nil
            }
        } else {
            return nil
        }
    }

    func setCodable<T: Codable>(_ value: T?, forKey key: String) {
        do {
            let encoded = try JSONEncoder().encode(value)
            set(encoded, forKey: key)
        } catch {
            print(String(describing: error))
        }
    }
}

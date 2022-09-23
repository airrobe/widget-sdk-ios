//
//  AirRobeGetShoppingDataModel.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

// MARK: - GetShoppingDataModel
struct AirRobeGetShoppingDataModel: Codable {
    let data: AirRobeShoppingDataModel
}

// MARK: - ShoppingDataModel
struct AirRobeShoppingDataModel: Codable {
    let shop: AirRobeShopModel
}

// MARK: - ShopModel
struct AirRobeShopModel: Codable {
    let name: String
    let privacyUrl: String?
    let popupFindOutMoreUrl: String
    let categoryMappings: [AirRobeCategoryMapping]
    let minimumPriceThresholds: [AirRobeMinPriceThresholds]
    let widgetVariants: [AirRobeWidgetVariant]
}

// MARK: - CategoryMapping
struct AirRobeCategoryMapping: Codable {
    let from: String
    let to: String?
    let excluded: Bool
}

// MARK: - MinPriceThresholds
struct AirRobeMinPriceThresholds: Codable {
    let minimumPriceCents: Double
    let department: String?
    let `default`: Bool
}

// MARK: - WidgetVariant
struct AirRobeWidgetVariant: Codable {
    let disabled: Bool
    let splitTestVariant: String?
}

// MARK: - HashMap for the Category Mapping
struct AirRobeCategoryMappingHashMap: Codable {
    var categoryMappingsHashMap: [String:AirRobeCategoryMapping]
}

// MARK: - Return struct for Category Eligibility
struct AirRobeCategoryEligibility: Codable {
    let eligible: Bool
    let to: String
}

// MARK: - Extension for checking category Eligibility
extension AirRobeGetShoppingDataModel {
    func isBelowPriceThreshold(department: String?, price: Double) -> Bool {
        guard let department = department else {
            return false
        }
        if let applicablePriceThreshold = data.shop.minimumPriceThresholds.first(where: { $0.department?.lowercased() == department.lowercased() }) {
            return price < (applicablePriceThreshold.minimumPriceCents / 100)
        }
        if let applicablePriceThreshold = data.shop.minimumPriceThresholds.first(where: { $0.default }) {
            return price < (applicablePriceThreshold.minimumPriceCents / 100)
        }
        return false
    }
}

// MARK: - Extension for checking target split test variant
extension AirRobeGetShoppingDataModel {
    func getSplitTestVariant() -> AirRobeWidgetVariant? {
        if let testVariant = UserDefaults.standard.SplitTestVariant,
           data.shop.widgetVariants.contains(where: {
               $0.disabled == testVariant.disabled &&
               $0.splitTestVariant == testVariant.splitTestVariant
           })
        {
            return testVariant
        }
        if !data.shop.widgetVariants.isEmpty {
            let testVariant = data.shop.widgetVariants.randomElement()
            UserDefaults.standard.SplitTestVariant = testVariant
            return testVariant
        }
        UserDefaults.standard.SplitTestVariant = nil
        return nil
    }
}

extension AirRobeCategoryMappingHashMap {
    func checkCategoryEligible(items: [String]) -> AirRobeCategoryEligibility {
        guard
            let eligibleItem = items.first(where: { bestCategoryMapping(categoryArray: factorize(category: $0)).eligible })
        else {
            return AirRobeCategoryEligibility(eligible: false, to: "")
        }
        return AirRobeCategoryEligibility(eligible: true, to: bestCategoryMapping(categoryArray: factorize(category: eligibleItem)).to)
    }
}

private extension AirRobeCategoryMappingHashMap {
    func factorize(category: String, delimiter: String.Element = AirRobeStrings.delimiter) -> [String] {
        let parts = category.split(separator: delimiter)
        var array: [String] = []
        for i in 0..<parts.count {
            array.append(parts[0..<i+1].joined(separator:String(delimiter)))
        }
        return array.reversed()
    }

    func bestCategoryMapping(categoryArray: [String]) -> AirRobeCategoryEligibility {
        for category in categoryArray {
            if let filteredMapping = categoryMappingsHashMap[category] {
                guard let to = filteredMapping.to, !to.isEmpty, !filteredMapping.excluded else {
                    return AirRobeCategoryEligibility(eligible: false, to: "")
                }
                return AirRobeCategoryEligibility(eligible: true, to: to)
            }
        }
        return AirRobeCategoryEligibility(eligible: false, to: "")
    }
}

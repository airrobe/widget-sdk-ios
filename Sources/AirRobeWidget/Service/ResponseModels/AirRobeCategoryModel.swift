//
//  AirRobeCategoryModel.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

// MARK: - CategoryModel
struct AirRobeCategoryModel: Codable {
    let data: AirRobeDataModel
}

// MARK: - DataModel
struct AirRobeDataModel: Codable {
    let shop: AirRobeShopModel
}

// MARK: - ShopModel
struct AirRobeShopModel: Codable {
    let categoryMappings: [AirRobeCategoryMapping]
}

// MARK: - CategoryMapping
struct AirRobeCategoryMapping: Codable {
    let from: String
    let to: String?
    let excluded: Bool
}

// MARK: - Return struct for Category Eligibility
struct AirRobeCategoryEligibility: Codable {
    let eligible: Bool
    let to: String
}

// MARK: - Extension for checking category Eligibility
extension AirRobeCategoryModel {
    func checkCategoryEligible(items: [String]) -> AirRobeCategoryEligibility {
        guard
            let eligibleItem = items.first(where: { bestCategoryMapping(categoryArray: factorize(category: $0)).eligible })
        else {
            return AirRobeCategoryEligibility(eligible: false, to: "")
        }
        return AirRobeCategoryEligibility(eligible: true, to: bestCategoryMapping(categoryArray: factorize(category: eligibleItem)).to)
    }
}

private extension AirRobeCategoryModel {
    func factorize(category: String, delimiter: String.Element = AirRobeStrings.delimiter) -> [String] {
        let parts = category.split(separator: delimiter)
        var array: [String] = []
        for i in 0..<parts.count {
            array.append(parts[0..<i+1].joined(separator:String(delimiter)))
        }
        return array.reversed()
    }

    func bestCategoryMapping(categoryArray: [String]) -> AirRobeCategoryEligibility {
        let categoryMappings = data.shop.categoryMappings
        for category in categoryArray {
            let filteredMapping = categoryMappings.first { $0.from == category }
            if let filteredMapping = filteredMapping {
                guard let to = filteredMapping.to, !to.isEmpty, !filteredMapping.excluded else {
                    return AirRobeCategoryEligibility(eligible: false, to: "")
                }
                return AirRobeCategoryEligibility(eligible: true, to: to)
            }
        }
        return AirRobeCategoryEligibility(eligible: false, to: "")
    }
}

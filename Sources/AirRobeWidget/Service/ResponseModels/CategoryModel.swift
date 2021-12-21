//
//  CategoryModel.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

// MARK: - CategoryModel
struct CategoryModel: Codable {
    let data: DataModel
}

// MARK: - DataModel
struct DataModel: Codable {
    let shop: ShopModel
}

// MARK: - ShopModel
struct ShopModel: Codable {
    let categoryMappings: [CategoryMapping]
}

// MARK: - CategoryMapping
struct CategoryMapping: Codable {
    let from: String
    let to: String?
    let excluded: Bool
}

// MARK: - Return struct for Category Eligibility
struct CategoryEligibility: Codable {
    let eligible: Bool
    let to: String
}

// MARK: - Extension for checking category Eligibility
extension CategoryModel {
    func checkCategoryEligible(items: [String]) -> CategoryEligibility {
        guard
            let eligibleItem = items.first(where: { bestCategoryMapping(categoryArray: factorize(category: $0)).eligible })
        else {
            return CategoryEligibility(eligible: false, to: "")
        }
        return CategoryEligibility(eligible: true, to: bestCategoryMapping(categoryArray: factorize(category: eligibleItem)).to)
    }
}

private extension CategoryModel {
    func factorize(category: String, delimeter: String.Element = Strings.delimeter) -> [String] {
        let parts = category.split(separator: delimeter)
        var array: [String] = []
        for i in 0..<parts.count {
            array.append(parts[0..<i+1].joined(separator:String(delimeter)))
        }
        return array.reversed()
    }

    func bestCategoryMapping(categoryArray: [String]) -> CategoryEligibility {
        let categoryMappings = data.shop.categoryMappings
        for category in categoryArray {
            let filteredMapping = categoryMappings.first { $0.from == category }
            if let filteredMapping = filteredMapping {
                guard let to = filteredMapping.to, !to.isEmpty, !filteredMapping.excluded else {
                    return CategoryEligibility(eligible: false, to: "")
                }
                return CategoryEligibility(eligible: true, to: to)
            }
        }
        return CategoryEligibility(eligible: false, to: "")
    }
}

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
        let categoryMappings = data.shop.categoryMappings
        let filteredCategoryMappings = categoryMappings.filter { items.contains($0.from) }
        guard !filteredCategoryMappings.isEmpty else {
            return CategoryEligibility(eligible: false, to: "")
        }
        let filteredByExcludedAndTo = filteredCategoryMappings.first {
            guard let to = $0.to else {
                return false
            }
            return !to.isEmpty && !$0.excluded
        }
        guard let filteredByExcludedAndTo = filteredByExcludedAndTo, let to = filteredByExcludedAndTo.to else {
            return CategoryEligibility(eligible: false, to: "")
        }
        return CategoryEligibility(eligible: true, to: to)
    }

}

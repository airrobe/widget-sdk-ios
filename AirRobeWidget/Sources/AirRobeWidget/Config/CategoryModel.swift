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

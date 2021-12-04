//
//  PriceEngineResponseModel.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation

// MARK: - PriceEngineResponseModel
struct PriceEngineResponseModel: Codable {
    let engine: String
    let result: ResultModel?
}

// MARK: - ResultModel
struct ResultModel: Codable {
    let hits: HitsModel
    let resaleValuePercentage: Int
    let resaleValue: Int?
    let weight: Double
}

// MARK: - HitsModel
struct HitsModel: Codable {
    let brand, category, material: Bool
}

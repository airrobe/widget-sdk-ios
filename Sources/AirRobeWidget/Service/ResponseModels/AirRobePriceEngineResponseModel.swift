//
//  AirRobePriceEngineResponseModel.swift
//  
//
//  Created by King on 11/26/21.
//

import Foundation

// MARK: - PriceEngineResponseModel
struct AirRobePriceEngineResponseModel: Codable {
    let engine: String
    let result: AirRobeResultModel?
}

// MARK: - ResultModel
struct AirRobeResultModel: Codable {
    let hits: AirRobeHitsModel
    let resaleValuePercentage: Int
    let resaleValue: Int?
    let weight: Double
}

// MARK: - HitsModel
struct AirRobeHitsModel: Codable {
    let brand, category, material: Bool
}

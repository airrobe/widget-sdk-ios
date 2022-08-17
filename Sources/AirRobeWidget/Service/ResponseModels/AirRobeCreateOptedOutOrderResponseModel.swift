//
//  AirRobeCreateOptedOutOrderResponseModel.swift
//  
//
//  Created by King on 8/17/22.
//

import Foundation

// MARK: - GetShoppingDataModel
struct AirRobeCreateOptedOutOrderResponseModel: Codable {
    let data: AirRobeCreateOptedOutOrderDataModel
}

// MARK: - CreateOptedOutOrderDataModel
struct AirRobeCreateOptedOutOrderDataModel: Codable {
    let createOptedOutOrder: AirRobeCreateOptedOutOrderModel
}

// MARK: - CreateOptedOutOrderModel
struct AirRobeCreateOptedOutOrderModel: Codable {
    let created: Bool
    let error: String?
}

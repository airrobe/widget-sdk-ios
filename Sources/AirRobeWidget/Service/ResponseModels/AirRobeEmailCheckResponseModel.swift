//
//  AirRobeEmailCheckResponseModel.swift
//  
//
//  Created by King on 12/9/21.
//

import Foundation

// MARK: - EmailCheckResponseModel
struct AirRobeEmailCheckResponseModel: Codable {
    let data: AirRobeEmailCheckDataModel
}

// MARK: - EmailCheckDataModel
struct AirRobeEmailCheckDataModel: Codable {
    let isCustomer: Bool
}

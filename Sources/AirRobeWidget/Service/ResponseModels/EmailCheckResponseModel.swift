//
//  EmailCheckResponseModel.swift
//  
//
//  Created by King on 12/9/21.
//

import Foundation

// MARK: - EmailCheckResponseModel
struct EmailCheckResponseModel: Codable {
    let data: EmailCheckDataModel
}

// MARK: - EmailCheckDataModel
struct EmailCheckDataModel: Codable {
    let isCustomer: Bool
}

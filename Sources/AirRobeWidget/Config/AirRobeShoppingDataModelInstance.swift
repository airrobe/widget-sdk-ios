//
//  AirRobeShoppingDataModelInstance.swift
//  
//
//  Created by King on 12/2/21.
//

import Foundation

class AirRobeShoppingDataModelInstance {
    @Published var shoppingDataModel: AirRobeGetShoppingDataModel?
    var categoryMapping = AirRobeCategoryMappingHashMap(categoryMappingsHashMap: [:])
    static let shared = AirRobeShoppingDataModelInstance()
    init() { }
}

//
//  AirRobeCategoryModelInstance.swift
//  
//
//  Created by King on 12/2/21.
//

import Foundation

class AirRobeCategoryModelInstance {
    @Published var categoryModel: AirRobeCategoryModel?
    static let shared = AirRobeCategoryModelInstance()
    init() { }
}

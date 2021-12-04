//
//  CategoryModelInstance.swift
//  
//
//  Created by King on 12/2/21.
//

import Foundation

class CategoryModelInstance {
    @Published var categoryModel: CategoryModel?
    static let shared = CategoryModelInstance()
    init() { }
}

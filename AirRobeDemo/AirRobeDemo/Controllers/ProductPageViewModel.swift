//
//  ProductPageViewModel.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import Foundation
final class ProductPageViewModel {
    var cellViewModel: ItemModel?

    func initCell(at index: Int) -> ItemModel? {
        return products[index]
    }
}

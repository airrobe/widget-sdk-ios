//
//  Consts.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import Foundation

struct ItemModel: Codable {
    let image: String
    let title: String
    let subTitle: String
    let price: String
    let category: String
}

typealias ItemModels = [ItemModel]

let products: ItemModels = [
    ItemModel(image: "bag1", title: "Aquila", subTitle: "Montoro Messenger", price: "$34.00", category: "Accessories"),
    ItemModel(image: "bag4", title: "Fjallraven", subTitle: "Kanken Totepack", price: "$174.95", category: "Accessories"),
    ItemModel(image: "bag5", title: "Stale Superior", subTitle: "Downtown Weekender", price: "$59.99", category: "Accessories"),
    ItemModel(image: "bag6", title: "Stale Superior", subTitle: "Downtown Weekender", price: "$59.99", category: "Accessories"),
    ItemModel(image: "gift1", title: "Happy Socks", subTitle: "Get Set 24 days Of Holiday Socks", price: "$399.00", category: "Accessories/Beauty"),
    ItemModel(image: "gift2", title: "Happy Socks", subTitle: "Get Set Sports 3-Pack", price: "$54.95", category: "Accessories/Beauty"),
    ItemModel(image: "gift3", title: "Tissot", subTitle: "Supersport Gent", price: "$500.00", category: "Accessories/Beauty"),
    ItemModel(image: "gift4", title: "Typo", subTitle: "Art Gift Set", price: "$49.99", category: "Accessories/Beauty")
]

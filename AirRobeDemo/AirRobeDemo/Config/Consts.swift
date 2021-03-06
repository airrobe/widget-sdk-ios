//
//  Consts.swift
//  AirRobeDemo
//
//  Created by King on 12/8/21.
//

import Foundation
import UIKit

struct ItemModel: Codable {
    let image: String
    let title: String
    let subTitle: String
    let price: String
    let category: String
}

typealias ItemModels = [ItemModel]

let products: ItemModels = [
    ItemModel(image: "bag1", title: "Aquila", subTitle: "Montoro Messenger", price: "$340.00", category: "Accessories"),
    ItemModel(image: "bag4", title: "Fjallraven", subTitle: "Kanken Totepack", price: "$174.95", category: "Accessories"),
    ItemModel(image: "bag5", title: "Stale Superior", subTitle: "Downtown Weekender", price: "$59.99", category: "Accessories"),
    ItemModel(image: "bag6", title: "Stale Superior", subTitle: "Downtown Weekender", price: "$59.99", category: "Accessories"),
    ItemModel(image: "gift1", title: "Happy Socks", subTitle: "Get Set 24 days Of Holiday Socks", price: "$399.00", category: "Accessories/Beauty"),
    ItemModel(image: "gift2", title: "Happy Socks", subTitle: "Get Set Sports 3-Pack", price: "$54.95", category: "Accessories/Beauty"),
    ItemModel(image: "gift3", title: "Tissot", subTitle: "Supersport Gent", price: "$500.00", category: "Accessories/Beauty"),
    ItemModel(image: "gift4", title: "Typo", subTitle: "Art Gift Set", price: "$49.99", category: "Accessories/Beauty")
]

struct CategoryModel {
    let category: String
    let image: UIImage
}

typealias CategoryModels = [CategoryModel]

let brands: CategoryModels = [
    CategoryModel(category: "Women", image: UIImage(named: "woman") ?? UIImage()),
    CategoryModel(category: "Men", image: UIImage(named: "man") ?? UIImage()),
    CategoryModel(category: "Kids", image: UIImage(named: "toy") ?? UIImage()),
    CategoryModel(category: "Beauty", image: UIImage(named: "beauty") ?? UIImage()),
    CategoryModel(category: "Sport", image: UIImage(named: "sports") ?? UIImage()),
    CategoryModel(category: "Home", image: UIImage(named: "home") ?? UIImage()),
]

let categories: CategoryModels = [
    CategoryModel(category: "New Arrivals", image: UIImage(named: "new_arrival") ?? UIImage()),
    CategoryModel(category: "Clothing", image: UIImage(named: "clothing") ?? UIImage()),
    CategoryModel(category: "Sport", image: UIImage(named: "sports_wear") ?? UIImage()),
    CategoryModel(category: "Shoes", image: UIImage(named: "shoes") ?? UIImage()),
    CategoryModel(category: "Accessories", image: UIImage(named: "accessories") ?? UIImage()),
    CategoryModel(category: "Gifts", image: UIImage(named: "gifts") ?? UIImage()),
    CategoryModel(category: "Designer", image: UIImage(named: "designer") ?? UIImage()),
    CategoryModel(category: "Essentials", image: UIImage(named: "essentials") ?? UIImage()),
    CategoryModel(category: "Denim", image: UIImage(named: "denim") ?? UIImage()),
    CategoryModel(category: "Sale", image: UIImage(named: "sales") ?? UIImage())
]

let subCategories: [String] = [
    "All Clothing",
    "T-shirt & Singlets",
    "Shirts & Polos",
    "Pants",
    "Sweats & Hoodies",
    "Shorts",
    "Coats & Jackets",
    "Jeans",
    "Swimwear",
    "Suits & Blazers",
    "Jumpers & Cardigans",
    "Sleepwear",
    "Underwear & Socks",
    "Tops"
]

import XCTest
@testable import AirRobeWidget

final class AirRobeWidgetTests: XCTestCase {
    var categoryModel: AirRobeGetShoppingDataModel?

    func testJSONMapping() throws {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "mappingInfo", withExtension: "json") else {
            XCTFail("Missing file: mappingInfo.json")
            return
        }

        let json = try Data(contentsOf: url)
        categoryModel = try JSONDecoder().decode(AirRobeGetShoppingDataModel.self, from: json)

        if categoryModel == nil {
            XCTFail("Parsing issue: mappingInfo.json")
            return
        }
    }

    func testAirRobeOptInView() throws {
        try testJSONMapping()
        AirRobeShoppingDataModelInstance.shared.shoppingDataModel = categoryModel

        let widgetInputs = [("Chanel", "Leather", "Accessories/Belts", 100.0, 80.0, 80.0)] + self.optInInputs
        let expectedResults = [true] + self.optInExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeOptIn()
            vm.initialize(brand: input.brand, material: input.material, category: input.category, priceCents: input.priceCents, originalFullPriceCents: input.originalFullPriceCents, rrpCents: input.rrpCents)
            let results = vm.optInView.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let optInInputs: [(brand: String?, material: String?, category: String, priceCents: Double, originalFullPriceCents: Double?, rrpCents: Double?)] = [
        ("", "", "Accessories/Belts", 100.0, 80.0, 80.0), // empty brand, material
        (nil, nil, "Accessories", 100.0, 80.0, 80.0), //nil brand, material
        (nil, nil, "Accessories", 100.0, nil, nil), //nil originalPrice, rrp
        (nil, nil, "Accessories", 100.0, 80.0, nil), //nil rrp
        (nil, nil, "Accessories", 100.0, nil, 80.0), //nil originalPrice
        ("brand", "material", "Accessories", 100.0, nil, nil), //nil brand, material
        ("brand", "material", "Accessories", 0, nil, nil), // 0 price
        (nil, nil, "Accessories", 0, nil, nil), //nil brand, material

        (nil, nil, "", 100.0, 80.0, 80.0), //empty string for category
        (nil, nil, "Accessories/Bags and Wallets/Bags", 100.0, 80.0, 80.0), //category input that `to` value is nil
        (nil, nil, "Shoes/Ankle Boots/Heeled Ankle Boots", 100.0, 80.0, 80.0), //category input that `to` value is empty string

        (nil, nil, "Accessories/Travel and Luggage", 100.0, 80.0, 80.0), //all case meets
        (nil, nil, "Accessories/Travel and Luggage/Test Category", 100.0, 80.0, 80.0), // applied for best category mapping logic - should true
        (nil, nil, "Accessories/Travel and Luggage/Home", 100.0, 80.0, 80.0), // applied for best category mapping logic - should be false because this category has `nil` for `to` value
        (nil, nil, "Accessories/Underwear & Socks", 100.0, 80.0, 80.0), // all case meets except excluded is true - so should be false
        (nil, nil, "Accessories/Underwear & Socks/Test Category", 100.0, 80.0, 80.0), // applied for best category mapping logic - should be false
    ]

    lazy var optInExpectedResults: [Bool] = [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,

        false,
        false,
        false,

        true,
        true,
        false,
        false,
        false
    ]

    func testAirRobeMultiOptInView() throws {
        try testJSONMapping()
        AirRobeShoppingDataModelInstance.shared.shoppingDataModel = categoryModel
        
        let widgetInputs = [["Accessories"]] + self.multiOptInInputs
        let expectedResults = [true] + self.multiOptInExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeMultiOptIn()
            vm.initialize(items: input)
            let results = vm.optInView.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let multiOptInInputs: [([String])] = [
        (["Accessories"]), // Contain a category that meets condition
        (["Accessories", "Accessories/Belts", ]), // Contain multiple categories that meets condition
        (["Accessories", "RandomCategory"]), // Contain 1 category that is in Mapping info that meets condition
        (["Accessories", "Accessories/All toys/Toys/Bags", "Accessories/All toys/Toys/Bags/Cross-body bags"]), // Contain only 1 category that is in Mapping info that meets condition, and the others with `to` value equals nil
        (["Accessories", "Accessories/All toys/Toys/Bags", "Accessories/Bags/Clutches"]), // Contain only 1 category that meets condition, and the others with `to` value equals empty string or nil

        ([]), // empty category
        (["Accessories/Underwear & Socks"]), // Contain 1 category that excluded equals true
        (["Accessories/Underwear & Socks", "Accessories/All toys/Toys/Bags", "Accessories/Bags/Clutches"]), // Contain 1 category that excluded equals true, and the others with `to` value equals empty string or nil
        (["Accessories/Underwear & Socks", "RandomCategory"]) // Contain a category that excluded equals true, and with random category
    ]

    lazy var multiOptInExpectedResults: [Bool] = [
        true,
        true,
        true,
        true,
        true,

        false,
        false,
        false,
        false
    ]

    // TODO: Add check email availablity Test
    func testAirRobeConfirmationView() throws {
        try testJSONMapping()
        AirRobeShoppingDataModelInstance.shared.shoppingDataModel = categoryModel
        
        let widgetInputs = [("123456", "michael@airrobe.com", true, true)] + self.confirmationInputs
        let expectedResults = [true] + self.confirmationExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeConfirmation()
            UserDefaults.standard.OptedIn = input.optIn
            UserDefaults.standard.OrderOptedIn = input.eligibility
            vm.initialize(orderId: input.orderId, email: input.email)
            let results = vm.orderConfirmationView.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let confirmationInputs: [(orderId: String, email: String, eligibility: Bool, optIn: Bool)] = [
        ("123456", "raj@airrobe.com", true, true), // optInfo in cache is set to true
        ("123456", "eli@airrobe.com", true, true), // with not available email

        ("", "", true, true), // order id and email is empty
        ("", "", true, false), // order id and email are empty and optInfo is false
        ("", "", true, false), // order id and email are empty and optInfo is false
        ("123456", "", true, true), // email is empty
        ("123456", "", true, false), // email is empty, optInfo in cache is set to false
        ("", "raj@airrobe.com", true, false), // orderId is empty, optInfo in cache is set to false
        ("", "raj@airrobe.com", true, true), // orderId is empty

        ("123456", "raj@airrobe.com", true, false), // with available email
        ("123456", "eli@airrobe.com", true, false), // with not available email

        // copy from above but eligibility set to false
        ("123456", "raj@airrobe.com", false, true),
        ("123456", "eli@airrobe.com", false, true),

        ("", "", false, true),
        ("", "", false, false),
        ("", "", false, false),
        ("123456", "", false, true),
        ("123456", "", false, false),
        ("", "raj@airrobe.com", false, false),
        ("", "raj@airrobe.com", false, true),

        ("123456", "raj@airrobe.com", false, false),
        ("123456", "eli@airrobe.com", false, false),
    ]

    lazy var confirmationExpectedResults: [Bool] = [
        true,
        true,

        false,
        false,
        false,
        false,
        false,
        false,
        false,

        false,
        false,

        // results for eligibilty as false
        false,
        false,

        false,
        false,
        false,
        false,
        false,
        false,
        false,

        false,
        false
    ]
}

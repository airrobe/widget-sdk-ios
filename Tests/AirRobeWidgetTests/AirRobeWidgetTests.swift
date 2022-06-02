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

        guard let categoryModel = categoryModel else {
            XCTFail("Parsing issue: mappingInfo.json")
            return
        }
        AirRobeShoppingDataModelInstance.shared.shoppingDataModel = categoryModel
        for i in 0..<categoryModel.data.shop.categoryMappings.count {
            AirRobeShoppingDataModelInstance.shared.categoryMapping.categoryMappingsHashMap[categoryModel.data.shop.categoryMappings[i].from] = categoryModel.data.shop.categoryMappings[i]
        }
    }

    func testAirRobeOptInView() throws {
        try testJSONMapping()

        let widgetInputs = optInInputs
        let expectedResults = optInExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeOptIn()
            vm.initialize(brand: input.brand, material: input.material, category: input.category, department: input.department, priceCents: input.priceCents, originalFullPriceCents: input.originalFullPriceCents, rrpCents: input.rrpCents)
            let results = vm.optInView.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let optInInputs: [(brand: String?, material: String?, department: String?, category: String, priceCents: Double, originalFullPriceCents: Double?, rrpCents: Double?)] = [
        ("", "", nil, "Accessories/Belts", 100.0, 80.0, 80.0), // empty brand, material
        (nil, nil, nil, "Accessories", 100.0, 80.0, 80.0), // nil brand, material
        (nil, nil, nil, "Accessories", 100.0, nil, nil), // nil originalPrice, rrp
        (nil, nil, nil, "Accessories", 100.0, 80.0, nil), // nil rrp
        (nil, nil, nil, "Accessories", 100.0, nil, 80.0), // nil originalPrice
        ("brand", "material", nil, "Accessories", 100.0, nil, nil), // with brand, material

        (nil, nil, "kidswear", "Accessories/Belts", 100.0, nil, nil), // department as `kidswear` - should be true coz min price threshold is 29.9
        (nil, nil, "kidswear", "Accessories/Belts", 20.0, nil, nil), // department as `kidswear` - should be false coz min price threshold is 29.9
        (nil, nil, "test Department", "Accessories/Belts", 100.0, nil, nil), // department as `test Department` - should be true coz default min price threshold is 49.9
        (nil, nil, "test Department", "Accessories/Belts", 30.0, nil, nil), // department as `test Department` - should be false coz default min price threshold is 49.9

        (nil, nil, nil, "", 100.0, 80.0, 80.0), //empty string for category
        (nil, nil, nil, "Accessories/All Team Sports", 100.0, 80.0, 80.0), //category input that `to` value is nil

        (nil, nil, nil, "Accessories/Travel and Luggage", 100.0, 80.0, 80.0), //all case meets
        (nil, nil, nil, "Accessories/Travel and Luggage/Test Category", 100.0, 80.0, 80.0), // applied for best category mapping logic - should true
        (nil, nil, nil, "Accessories/Underwear/Test Category", 100.0, 80.0, 80.0), // applied for best category mapping logic - should be false because this category has `nil` for `to` value
        (nil, nil, nil, "Accessories/Underwear & Socks", 100.0, 80.0, 80.0), // all case meets except excluded is true - so should be false
        (nil, nil, nil, "Accessories/Underwear & Socks/Test Category", 100.0, 80.0, 80.0), // applied for best category mapping logic - should be false
    ]

    lazy var optInExpectedResults: [Bool] = [
        true,
        true,
        true,
        true,
        true,
        true,

        true,
        false,
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

        let widgetInputs = multiOptInInputs
        let expectedResults = multiOptInExpectedResults

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
        (["Accessories", "Accessories/All toys/Toys/Bags", "Root Category/Clothing/Sleepwear/Gowns/Loungewear"]), // Contain only 1 category that is in Mapping info that meets condition, and the others with `to` value equals nil

        ([]), // empty category
        (["Accessories/Underwear & Socks"]), // Contain 1 category that excluded equals true
        (["Accessories/Underwear & Socks", "RandomCategory"]) // Contain a category that excluded equals true, and with random category
    ]

    lazy var multiOptInExpectedResults: [Bool] = [
        true,
        true,
        true,
        true,

        false,
        false,
        false
    ]

    func testAirRobeConfirmationView() throws {
        try testJSONMapping()

        let widgetInputs = confirmationInputs
        let expectedResults = confirmationExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeConfirmation()
            UserDefaults.standard.OrderOptedIn = input.orderOptedIn
            vm.initialize(orderId: input.orderId, email: input.email, fraudRisk: input.fraudRisk)
            let results = vm.orderConfirmationView.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let confirmationInputs: [(orderId: String, email: String, fraudRisk: Bool, orderOptedIn: Bool)] = [
        ("123456", "michael@airrobe.com", false, true), // orderOptedIn in cache is true, orderId, email available
        ("123456", "eli@airrobe.com", false, false), // orderOptedIn in cache is false, orderId, email available

        ("", "", false, true), // both orderId and email are empty strings
        ("123456", "", false, true), // email is empty
        ("", "michael@airrobe.com", false, true), // orderId is empty

        ("123456", "eli@airrobe.com", true, true), // all good, but fraudRisk is true
    ]

    lazy var confirmationExpectedResults: [Bool] = [
        true,
        false,

        false,
        false,
        false,

        false
    ]
}

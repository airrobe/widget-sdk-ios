import XCTest
@testable import AirRobeWidget

final class AirRobeWidgetTests: XCTestCase {
    var categoryModel: CategoryModel?

    func testJSONMapping() throws {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: "mappingInfo", withExtension: "json") else {
            XCTFail("Missing file: mappingInfo.json")
            return
        }

        let json = try Data(contentsOf: url)
        categoryModel = try JSONDecoder().decode(CategoryModel.self, from: json)

        if categoryModel == nil {
            XCTFail("Parsing issue: mappingInfo.json")
            return
        }
    }

    func testAirRobeOptInView() throws {
        try testJSONMapping()
        CategoryModelInstance.shared.categoryModel = categoryModel

        let widgetInputs = [("Chanel", "Leather", "Accessories/Belts", 100.0, 80.0, 80.0, "AUD", "en-AU")] + self.otpInInputs
        let expectedResults = [true] + self.otpInExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeOptIn()
            vm.initialize(brand: input.brand, material: input.material, category: input.category, priceCents: input.priceCents, originalFullPriceCents: input.originalFullPriceCents, rrpCents: input.rrpCents, currency: input.currency, locale: input.locale)
            let results = vm.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let otpInInputs: [(brand: String?, material: String?, category: String, priceCents: Double, originalFullPriceCents: Double?, rrpCents: Double?, currency: String?, locale: String?)] = [
        ("", "", "Accessories/Belts", 100.0, 80.0, 80.0, "AUD", "en-AU"), // empty brand, material
        (nil, nil, "Accessories", 100.0, 80.0, 80.0, nil, nil), //nil brand, material
        (nil, nil, "Accessories", 100.0, nil, nil, "AUD", "en-AU"), //nil originalPrice, rrp
        (nil, nil, "Accessories", 100.0, 80.0, nil, "AUD", "en-AU"), //nil rrp
        (nil, nil, "Accessories", 100.0, nil, 80.0, "AUD", "en-AU"), //nil originalPrice
        ("brand", "material", "Accessories", 100.0, nil, nil, "AUD", "en-AU"), //nil brand, material
        ("brand", "material", "Accessories", 0, nil, nil, "AUD", "en-AU"), // 0 price
        (nil, nil, "Accessories", 0, nil, nil, nil, nil), //nil brand, material

        (nil, nil, "", 100.0, 80.0, 80.0, "AUD", "en-AU"), //empty string for category
        (nil, nil, "Accessories/Bags and Wallets/Bags", 100.0, 80.0, 80.0, "AUD", "en-AU"), //category input that `to` value is nil
        (nil, nil, "Shoes/Ankle Boots/Heeled Ankle Boots", 100.0, 80.0, 80.0, "AUD", "en-AU") //category input that `to` value is empty string
    ]

    lazy var otpInExpectedResults: [Bool] = [
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
        false
    ]

    func testAirRobeMultiOptInView() throws {
        try testJSONMapping()
        CategoryModelInstance.shared.categoryModel = categoryModel
        
        let widgetInputs = [["Accessories"]] + self.multiOtpInInputs
        let expectedResults = [true] + self.multiOtpInExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeMultiOptIn()
            vm.initialize(items: input)
            let results = vm.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let multiOtpInInputs: [([String])] = [
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

    lazy var multiOtpInExpectedResults: [Bool] = [
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
        CategoryModelInstance.shared.categoryModel = categoryModel
        
        let widgetInputs = [("123456", "michael@airrobe.com", true, true)] + self.confirmationInputs
        let expectedResults = [true] + self.confirmationExpectedResults

        XCTAssertEqual(widgetInputs.count, expectedResults.count)
        zip(widgetInputs, expectedResults).forEach { input, exp in
            let vm = AirRobeConfirmation()
            UserDefaults.standard.OptInfo = input.otpIn
            UserDefaults.standard.Eligibility = input.eligibility
            vm.initialize(orderId: input.orderId, email: input.email)
            let results = vm.viewModel.isAllSet == .eligible ? true : false
            XCTAssertEqual(results, exp)
        }
    }

    let confirmationInputs: [(orderId: String, email: String, eligibility: Bool, otpIn: Bool)] = [
        ("123456", "raj@airrobe.com", true, true), // otpInfo in cache is set to true
        ("123456", "eli@airrobe.com", true, true), // with not available email

        ("", "", true, true), // order id and email is empty
        ("", "", true, false), // order id and email are empty and otpInfo is false
        ("", "", true, false), // order id and email are empty and otpInfo is false
        ("123456", "", true, true), // email is empty
        ("123456", "", true, false), // email is empty, otpInfo in cache is set to false
        ("", "raj@airrobe.com", true, false), // orderId is empty, otpInfo in cache is set to false
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

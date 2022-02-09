//
//  AirRobeOptIn.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeOptIn: UIView {
    private var subscribers: [AnyCancellable] = []
    lazy var optInView: AirRobeOptInView = AirRobeOptInView.loadFromNib()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// initalizing AirRobeMultiOptIn
    /// - Parameters:
    ///   - brand: brand of the shopping item, optional value and can be dismissed
    ///   - material: material of the shopping item, optional value and can be dismissed
    ///   - category: category of the shopping item
    ///   - priceCents: price of the shopping item
    ///   - originalFullPriceCents: original full price of the shopping item, optional value and can be dismissed
    ///   - rrpCents: recommended retail price of the shopping item, optional value and can be dismissed
    ///   - currency: currency in 3 lettered characters, optional value and default value is "AUD"
    ///   - locale: locale, optional value and default value is "en-AU"
    public func initialize(
        brand: String? = nil,
        material: String? = nil,
        category: String,
        priceCents: Double,
        originalFullPriceCents: Double? = nil,
        rrpCents: Double? = nil,
        currency: String = "AUD",
        locale: String = "en-AU"
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        optInView.viewModel.brand = brand
        optInView.viewModel.material = material
        optInView.viewModel.category = category
        optInView.viewModel.priceCents = priceCents
        optInView.viewModel.originalFullPriceCents = originalFullPriceCents
        optInView.viewModel.rrpCents = rrpCents
        optInView.viewModel.currency = currency
        optInView.viewModel.locale = locale
        optInView.viewType = .optIn
        optInView.superView = self

        optInView.viewModel.initializeOptInWidget()
    }
}
#endif

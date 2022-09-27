//
//  AirRobeEnhancedStrings.swift
//  
//
//  Created by King on 9/27/22.
//

import Foundation

enum AirRobeEnhancedStrings {
    // MARK: - Title Strings
    static let added = "Added To"
    static let add = "Add To"

    // MARK: - Description Strings
    static let description = "Save to resell later."
    static let descriptionCutOffText = "Re-sell later."

    // MARK: - Potential Value Strings
    static let potentialValue = "Estimated resale: "
    static let potentialValueCuttOff = "Est. resale: "

    // MARK: - Detailed Description Strings
    static let detailedDescription = "AirRobe is the easiest way to resell, rent or recycle your fashion. “Add to AirRobe” to save all product details and imagery to your own digital Circular Wardrobe™ so you can list later on the AirRobe pre-loved marketplace in seconds. No fee to add. No commitment. \(learnMoreLinkText)"
    static let learnMoreLinkText = "Learn more."
    static let learnMoreLinkForPurpose = URL(string: "https://airrobe.com/")!

    // MARK: - Learn More Alert View Controller Strings
    static let learnMoreTitle = "The easiest way to resell, rent or recycle."
    static let learnMoreSubtitle = "Save your purchases to AirRobe so you can repurpose them later in seconds on the AirRobe pre-loved designer marketplace.\n\nNo fee to add. No commitment."
    static let learnHowItWorksTitle = "HOW AIRROBE WORKS"
    static let learnMoreStep1Title = "SHOP AS USUAL"
    static let learnMoreStep2Title = "‘Add to AirRobe’"
    static let learnMoreStep2Description = "All product detail & imagery will be saved to your digital Circular Wardrobe™ on AirRobe. Simply set up your account post-purchase."
    static let learnMoreStep3Title = "RESELL, RENT OR RECYCLE LATER"
    static let learnMoreStep3Description = "Once you’ve worn and loved an item, easily list from your AirRobe Circular Wardrobe™ in seconds."
    static let learnMoreText = "LEARN MORE"
    static let learnMoreClose = "CLOSE"

    // MARK: - Order Confirmation View Strings
    static let orderConfirmationTitle = "Your items are in"
    static let orderConfirmationDescription = "Simply activate your free account below to resell your items back into a circular economy after you’ve loved and worn them."
    static let orderConfirmationActivateText = "ACTIVATE YOUR AIRROBE ACCOUNT"
    static let orderConfirmationVisitText = "VISIT YOUR AIRROBE ACCOUNT"

    // MARK: - Order Activate baseURL
    static let orderActivateBaseUrl = "https://shop.airrobe.com/en/orders/"
    static let orderActivateSandBoxBaseUrl = "https://stg.marketplace.airdemo.link/en/orders/"

    // MARK: - Delimiter
    static let delimiter: String.Element = "/"
}

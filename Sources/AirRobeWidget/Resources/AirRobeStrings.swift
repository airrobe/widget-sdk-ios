//
//  AirRobeStrings.swift
//  
//
//  Created by King on 11/23/21.
//

import Foundation

enum AirRobeStrings {
    // MARK: - Title Strings
    static let added = "Added To"
    static let add = "Add To"

    // MARK: - Description Strings
    static let description = "Wear now, re-sell later."
    static let descriptionCutOffText = "Re-sell later."

    // MARK: - Description Strings (Variant 2)
    static let descriptionVariant2 = "Save to resell later."

    // MARK: - Potential Value Strings
    static let potentialValue = "Potential value: "

    // MARK: - Potential Value Strings (Variant 2)
    static let potentialValueVariant2 = "Estimated resale: "
    static let potentialValueVariant2CuttOff = "Est. resale: "

    // MARK: - Detailed Description Strings
    static let detailedDescription = "We’ve partnered with AirRobe to enable you to join the circular fashion movement. Re-sell or rent your purchases on AirRobe’s marketplace – all with one simple click. Together, we can do our part to keep fashion out of landfill. \(learnMoreLinkText)"
    static let learnMoreLinkText = "Learn more."
    static let learnMoreLinkForPurpose = URL(string: "https://airrobe.com/")!

    // MARK: - Detailed Description Strings (Variant 2)
    static let detailedDescriptionVariant2 = "AirRobe is the easiest way to resell, rent or recycle your fashion. “Add to AirRobe” to save all product details and imagery to your own digital Circular Wardrobe™ so you can list later on the AirRobe pre-loved marketplace in seconds. No fee to add. No commitment. \(learnMoreLinkText)"

    // MARK: - Extra Info Strings
    static let extraInfo = "By opting in you agree to \(companyNameText)’s \(extraLinkText) and consent for us to share your details with AirRobe."
    static let extraLinkText = "Privacy Policy"
    static let companyNameText = "COMPANY NAME"

    // MARK: - Get Shopping Data Query Strings
    static let GetShoppingDataQuery = """
                query GetShoppingData ($appId: String) {
                  shop(appId: $appId) {
                    name
                    privacyUrl
                    popupFindOutMoreUrl
                    categoryMappings(mappedOrExcludedOnly: true) {
                      from
                      to
                      excluded
                    }
                    minimumPriceThresholds {
                      default
                      department
                      minimumPriceCents
                    }
                  }
                }
            """

    // MARK: - Check Email Query Strings
    static let CheckEmailQuery = """
                query IsCustomer ($email: String!) {
                  isCustomer(email: $email)
                }
            """

    // MARK: - Create Opted Out Order Query Strings
    static let CreateOptedOutOrderQuery = """
                mutation CreateOptedOutOrder ($input: CreateOptedOutOrderMutationInput!) {
                  createOptedOutOrder (input: $input) {
                    created
                    error
                  }
                }
            """

    // MARK: - Learn More Alert View Controller Strings
    static let learnMoreTitle = "HOW IT WORKS"
    static let learnMoreStep1Title = "1. ADD TO AIRROBE"
    static let learnMoreStep1Description = "Toggling the AirRobe \"on\" will save your purchase (including all product information) to your private AirRobe account to re-sell later."
    static let learnMoreStep2Title = "2. RE-SELL LATER"
    static let learnMoreStep2Description = "After you've worn and loved your item, simply log into airrobe.com to list your item for sale on AirRobe’s marketplace – in one click."
    static let learnMoreQuestion = "What if I don't have an AirRobe account?"
    static let learnMoreAnswer = "Don't panic! You'll be directed to set up your free account at the order confirmation page."
    static let learnMoreReady = "READY TO GET STARTED?"
    static let learnMoreToggleOn = "TOGGLE ON!"
    static let learnMoreFindMoreText = "Find out more about AirRobe."

    // MARK: - Learn More Alert View Controller Strings (Variant 2)
    static let learnMoreTitleVariant2 = "The easiest way to resell, rent or recycle."
    static let learnMoreSubtitleVariant2 = "Save your purchases to AirRobe so you can repurpose them later in seconds on the AirRobe pre-loved designer marketplace.\n\nNo fee to add. No commitment."
    static let learnHowItWorksTitleVariant2 = "HOW AIRROBE WORKS"
    static let learnMoreStep1TitleVariant2 = "SHOP AS USUAL"
    static let learnMoreStep2TitleVariant2 = "‘Add to AirRobe’"
    static let learnMoreStep2DescriptionVariant2 = "All product detail & imagery will be saved to your digital Circular Wardrobe™ on AirRobe. Simply set up your account post-purchase."
    static let learnMoreStep3TitleVariant2 = "RESELL, RENT OR RECYCLE LATER"
    static let learnMoreStep3DescriptionVariant2 = "Once you’ve worn and loved an item, easily list from your AirRobe Circular Wardrobe™ in seconds."
    static let learnMoreTextVariant2 = "LEARN MORE"
    static let learnMoreCloseVariant2 = "CLOSE"

    // MARK: - Order Confirmation View Strings
    static let orderConfirmationTitle = "Your items are in"
    static let orderConfirmationDescription = "Simply activate your free account below to re-sell your items back into a circular economy after you`ve worn and loved them."
    static let orderConfirmationActivateText = "ACTIVATE YOUR AIRROBE ACCOUNT"
    static let orderConfirmationVisitText = "VISIT YOUR AIRROBE ACCOUNT"

    // MARK: - Order Confirmation View Strings (Variant 2)
    static let orderConfirmationDescriptionVariant2 = "Simply activate your free account below to resell your items back into a circular economy after you’ve loved and worn them."

    // MARK: - Order Activate baseURL
    static let orderActivateBaseUrl = "https://shop.airrobe.com/en/orders/"
    static let orderActivateSandBoxBaseUrl = "https://stg.marketplace.airdemo.link/en/orders/"

    // MARK: - Delimiter
    static let delimiter: String.Element = "/"
}

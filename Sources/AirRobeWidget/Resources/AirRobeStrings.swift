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

    // MARK: - Potential Value Strings
    static let potentialValue = "Potential value: "

    // MARK: - Detailed Description Strings
    static let detailedDescription = "We’ve partnered with AirRobe to enable you to join the circular fashion movement. Re-sell or rent your purchases on AirRobe’s marketplace – all with one simple click. Together, we can do our part to keep fashion out of landfill. \(learnMoreLinkText)"
    static let learnMoreLinkText = "Learn more."
    static let learnMoreLinkForPurpose = URL(string: "https://airrobe.com/")!

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
                    widgetVariants {
                      disabled
                      splitTestVariant
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

    // MARK: - Order Confirmation View Strings
    static let orderConfirmationTitle = "Your items are in"
    static let orderConfirmationDescription = "Simply activate your free account below to re-sell your items back into a circular economy after you`ve worn and loved them."
    static let orderConfirmationActivateText = "ACTIVATE YOUR AIRROBE ACCOUNT"
    static let orderConfirmationVisitText = "VISIT YOUR AIRROBE ACCOUNT"

    // MARK: - Order Activate baseURL
    static let orderActivateBaseUrl = "https://shop.airrobe.com/en/orders/"
    static let orderActivateSandBoxBaseUrl = "https://stg.marketplace.airdemo.link/en/orders/"

    // MARK: - Delimiter
    static let delimiter: String.Element = "/"
}

//
//  Strings.swift
//  
//
//  Created by King on 11/23/21.
//

import Foundation

enum Strings {
    // MARK: - Title Strings

    static let added = "Added To"
    static let add = "Add To"

    // MARK: - Description Strings

    static let description = "Wear now, re-sell later."

    // MARK: - Potential Value Strings

    static let potentialValue = "Potential value: "

    // MARK: - Detailed Description Strings

    static let detailedDescription = "We’ve partnered with AirRobe to enable you to join the circular fashion movement. Re-sell or rent your purchases on AirRobe’s marketplace – all with one simple click. Together, we can do our part to keep fashion out of landfill. Learn more."
    static let learnMoreLinkText = "Learn more."

    // MARK: - Extra Info Strings

    static let extraInfo = "By opting in you agree to THE ICONIC’s Privacy Policy and consent for us to share your details with AirRobe."
    static let extraLinkText = "Privacy Policy"
    static let extraLink = URL(string: "https://www.theiconic.com.au/privacy-policy")!

    // MARK: - Get Mapping Info Query Strings
    static let GetMappingInfoQueryAppIdKey = "APP_ID"
    static let GetMappingInfoQuery = """
                query GetMappingInfo {
                  shop(appId: "APP_ID") {
                    categoryMappings {
                      from
                      to
                      excluded
                    }
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
    static let learnMoreFindMoreLink = URL(string:"https://www.theiconic.com.au/airrobe/")!
}

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
    static let extraLink = "https://www.theiconic.com.au/privacy-policy"

    // MARK: - Get Mapping Info Query String
    static let GetMappingInfoQuery = """
                query GetMappingInfo {
                  shop {
                    categoryMappings {
                      from
                      to
                      excluded
                    }
                  }
                }
            """
}

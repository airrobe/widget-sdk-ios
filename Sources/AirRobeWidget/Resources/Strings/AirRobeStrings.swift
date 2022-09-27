//
//  AirRobeStrings.swift
//  
//
//  Created by King on 9/27/22.
//

import Foundation

enum AirRobeStrings {
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
}

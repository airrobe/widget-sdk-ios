//
//  AirRobeWidgetLoadState.swift
//  
//
//  Created by King on 12/17/21.
//

enum AirRobeWidgetLoadState: String {
    case initializing = "Widget Initializing"
    case widgetDisabled = "Widget is not enabled in target variant"
    case noCategoryMappingInfo = "Category Mapping Info is not loaded"
    case eligible
    case notEligible
    case paramIssue = "Required params can't be empty"
}

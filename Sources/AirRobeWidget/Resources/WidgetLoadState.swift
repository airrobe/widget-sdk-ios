//
//  WidgetLoadState.swift
//  
//
//  Created by King on 12/17/21.
//

enum WidgetLoadState: String {
    case initializing = "Widget Initializing"
    case noCategoryMappingInfo = "Category Mapping Info is not loaded"
    case eligible
    case notEligible
    case paramIssue = "Required params can't be empty"
}

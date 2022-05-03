//
//  AirRobeWidgetInfo.swift
//  
//
//  Created by King on 12/3/21.
//

import Foundation

/// AirRobe Widget data structure. Access `AirRobeWidgetInfo.current` for information
/// about your Widget version.
public struct AirRobeWidgetInfo {
    /// Instance of the current AirRobeWidget instance.
    public static var current: AirRobeWidgetInfo {
        AirRobeWidgetInfo(version: AirRobeWidgetInfo.version, platform: AirRobeWidgetInfo.platform)
    }

    /// Platform that is being used: ios, macos, unknown
    fileprivate(set) var platform: String

    /// Version of Widget being used
    fileprivate(set) var version: String

    /// Version of Widget being used
    static let version = "1.0.6"

    #if os(iOS)
    /// Platform that is being used: ios, macos, unknown
    static let platform = "ios"
    #elseif os(macOS)
    /// Platform that is being used: ios, macos, unknown
    static let platform = "macos"
    #else
    /// Platform that is being used: ios, macos, unknown
    static let platform = "unknown"
    #endif

    fileprivate init(version: String, platform: String) {
        self.version = version
        self.platform = platform
    }

    func prettyPrint() -> String {
        """
            version: \(AirRobeWidgetInfo.version)
            platform: \(platform)
        """
    }
}

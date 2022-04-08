//
//  Utils.swift
//  
//
//  Created by King on 12/1/21.
//

#if canImport(UIKit)
import UIKit

struct AirRobeUtils {

    static func openUrl(_ url: URL?) {
        guard let url = url else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    print("Opened URL \(url) successfully")
                }
                else {
                    print("Failed to open URL \(url)")
                }
            })
        }
        else {
            print("Can't open the URL: \(url)")
        }
    }

    static func telemetryEvent(eventName: String, widgetName: String) {
        let apiService = AirRobeApiService()
        _ = apiService.telemetryEvent(eventName: eventName, widgetName: widgetName)
        print("Telemetry Event => event: " + eventName + ", widgetName: " + widgetName)
    }

}
#endif

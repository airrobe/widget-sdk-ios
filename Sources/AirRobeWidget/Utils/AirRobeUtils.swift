//
//  Utils.swift
//  
//
//  Created by King on 12/1/21.
//

#if canImport(UIKit)
import UIKit
import Combine

private var cancellable: AnyCancellable?
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

    static func telemetryEvent(
        eventName: String,
        pageName: String,
        brand: String? = nil,
        material: String? = nil,
        category: String? = nil,
        department: String? = nil
    ) {
        let apiService = AirRobeApiService()
        cancellable = apiService.telemetryEvent(
            eventName: eventName,
            pageName: pageName,
            brand: brand,
            material: material,
            category: category,
            department: department
        )
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    #if DEBUG
                    print("Telemetry Event error: ", error)
                    #endif
                case .finished:
                    print(completion)
                }
            }, receiveValue: {
                print("Telemetry Event Succeed:", $0)
            })
        print("Telemetry Event => event: " + eventName + ", pageName: " + pageName)
    }

    static func dispatchEvent(eventName: String, pageName: String) {
        guard let event = EventName.init(rawValue: eventName) else {
            return
        }
        let eventData = AirRobeEventData(
            app_id: configuration?.appId ?? "",
            anonymous_id: UIDevice.current.identifierForVendor?.uuidString ?? "",
            session_id: sessionId,
            event_name: event,
            source: AirRobeWidgetInfo.platform,
            version: AirRobeWidgetInfo.version,
            split_test_variant: UserDefaults.standard.TargetSplitTestVariant?.splitTestVariant ?? "default",
            page_name: PageName.init(rawValue: pageName) ?? .other
        )

        delegate?.onEventEmitted(event: eventData)
    }

}
#endif

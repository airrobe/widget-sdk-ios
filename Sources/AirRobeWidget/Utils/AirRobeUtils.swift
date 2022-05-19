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

    static func telemetryEvent(eventName: String, pageName: String) {
        let apiService = AirRobeApiService()
        cancellable = apiService.telemetryEvent(eventName: eventName, pageName: pageName)
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
        delegate?.onEventEmitted(event: "Event Emitted")
    }

}
#endif

//
//  AirRobeWidget.swift
//
//
//  Created by King on 11/22/21.
//

import Foundation
import Combine

/// AirRobe Widget data structure. Access `AirRobeWidget.current` for information
/// about your Widget version.
public struct AirRobeWidget {
    /// Instance of the current AirRobeWidget instance.
    public static var current: AirRobeWidget {
        AirRobeWidget(version: AirRobeWidget.version, platform: AirRobeWidget.platform)
    }

    /// Platform that is being used: ios, macos, unknown
    fileprivate(set) var platform: String

    /// Version of Widget being used
    fileprivate(set) var version: String

    /// Version of Widget being used
    static let version = "1.0.0"

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
            version: \(AirRobeWidget.version)
            platform: \(platform)
        """
    }
}

extension AirRobeWidget {

    public func initialize(config: AirRobeWidgetConfig) {
        let endpoint: String = {
            switch config.mode {
            case .production:
                return AirRobeHost.airRobeConnectorProduction.rawValue
            case .sandbox :
                return AirRobeHost.airRobeConnectorSandbox.rawValue
            }
        }()

        guard let url = URL(string: endpoint) else {
            print("Failed to Load AirRobe Connector Endpoint")
            return
        }

        getMappingInfo(GraphQLOperation.fetchPost(url: url, appId: config.appId)) { (category) in
            CategoryModelInstance.shared.categoryModel = category
        }
    }

    public func clearCache() {
        UserDefaults.standard.OtpInfo = false
    }

    fileprivate func getMappingInfo(_ operation: GraphQLOperation, completion: @escaping (CategoryModel) -> Void) {
        let request: URLRequest

        do {
            request = try operation.getURLRequest()
        } catch {
            return
        }

        let getMappingInfoTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with fetching mapping info: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }

            guard let data = data,
                let mappingInfos = try? JSONDecoder().decode(CategoryModel.self, from: data) else {
                    print("Error with the data")
                    return
            }
            completion(mappingInfos)
        }
        getMappingInfoTask.resume()
    }

}

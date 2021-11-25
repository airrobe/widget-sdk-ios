//
//  AirRobeWidgetBuild.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

final public class AirRobeWidgetBuild {
    var categoryModel: CategoryModel?
    private let config: AirRobeWidgetConfig

    public init(config: AirRobeWidgetConfig) {
        self.config = config
    }

    private init() { fatalError("You must provide settings when creating the AirRobeWidget") }

    public func build() {
        getMappingInfo(config: config) { [weak self] (category) in
            guard let self = self else {
                return
            }
            #if DEBUG
            print("Category Mapping Info", category)
            #endif
            self.categoryModel = category
            UserDefaults.standard.categoryMappingInfo = category
        }
    }

    fileprivate func getMappingInfo(config: AirRobeWidgetConfig, completionHandler: @escaping (CategoryModel) -> Void) {

        guard let url = URL(string: AirRobeHost.airRobeConnectorSandbox.rawValue) else {
            print("Failed to Load AirRobe Connector Endpoint")
            return
        }

        /// GetMappingInfo Query for AirRobe Connector GraphQL
        let params: [String: String?] = [
            "query": "query GetMappingInfo {\n    shop {\n        categoryMappings {\n            from\n            to\n            excluded\n        }\n    }\n}",
            "variables": nil,
            "operationName": "GetMappingInfo"
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Application/json", forHTTPHeaderField: "Accept")
        request.addValue(config.appId, forHTTPHeaderField: "x-airrobe-app-id")
        request.addValue("XhMrE0hVul9M52f2VPjT61AToEEXHiI2Qywkm7RgIEw=", forHTTPHeaderField: "x-airrobe-hmac-sha256")
        request.httpMethod = "POST"
        request.httpBody = httpBody
        let getMappingInfoTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            completionHandler(mappingInfos)
        }
        getMappingInfoTask.resume()

    }

}

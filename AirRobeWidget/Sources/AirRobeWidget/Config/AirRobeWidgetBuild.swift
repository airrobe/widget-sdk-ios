//
//  AirRobeWidgetBuild.swift
//  
//
//  Created by King on 11/25/21.
//

import Foundation

final public class AirRobeWidgetBuild {
    private let config: AirRobeWidgetConfig

    public init(config: AirRobeWidgetConfig) {
        self.config = config
    }

    private init() { fatalError("You must provide settings when creating the AirRobeWidget") }

    public func build() {
        UserDefaults.standard.shouldLoadWidget = false
        let endpoint: String = {
            switch self.config.mode {
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
            UserDefaults.standard.categoryMappingInfo = category
            UserDefaults.standard.shouldLoadWidget = true
        }
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
                UserDefaults.standard.categoryMappingInfo = nil
                UserDefaults.standard.shouldLoadWidget = true
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    UserDefaults.standard.categoryMappingInfo = nil
                    UserDefaults.standard.shouldLoadWidget = true
                return
            }

            guard let data = data,
                let mappingInfos = try? JSONDecoder().decode(CategoryModel.self, from: data) else {
                    UserDefaults.standard.categoryMappingInfo = nil
                    UserDefaults.standard.shouldLoadWidget = true
                    print("Error with the data")
                    return
            }
            completion(mappingInfos)
        }
        getMappingInfoTask.resume()
    }
}

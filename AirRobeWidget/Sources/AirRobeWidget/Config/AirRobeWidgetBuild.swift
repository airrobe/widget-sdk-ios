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
        guard let url = URL(string: AirRobeHost.airRobeConnectorSandbox.rawValue) else {
            print("Failed to Load AirRobe Connector Endpoint")
            return
        }

        getMappingInfo(GraphQLOperation.fetchPost(url: url, appId: config.appId)) { [weak self] (category) in
            guard let self = self else {
                return
            }
            self.categoryModel = category
            UserDefaults.standard.categoryMappingInfo = category
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

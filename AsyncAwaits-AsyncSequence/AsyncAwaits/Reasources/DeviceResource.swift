//
//  DeviceResource.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import Foundation
class DeviceResource{
    func getDevices() async throws -> [Device] {
        guard let url = Endpoint.getDevices.url(for: .production) else{
            throw ApiError.invalidUrl
        }
        let urlRequest = URLRequest(url: url)
        do {
            let deviceResponse = try await NetworkUtility.shared.performOperation(request: urlRequest, response: DeviceResponse.self)
            guard let device = deviceResponse.data else{
                return []
            }
            return device
        } catch  {
            throw error
        }
    }
}

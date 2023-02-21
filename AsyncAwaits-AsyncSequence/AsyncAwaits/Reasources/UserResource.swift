//
//  UserResource.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import Foundation
class UserResource{
    func getUsers() async throws -> [User] {
        guard let url = Endpoint.getUsers.url(for: .production) else{
            throw ApiError.invalidUrl
        }
        let urlRequest = URLRequest(url: url)
        do {
            return try await NetworkUtility.shared.performOperation(request: urlRequest, response: [User].self)
        } catch  {
            throw error
        }
    }
}

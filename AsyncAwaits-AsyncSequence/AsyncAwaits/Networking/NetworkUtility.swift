//
//  NetworkUtility.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 19/01/23.
//


// Generic HTTP client we can use all over the project 

import Foundation

final class NetworkUtility{
    
    static let shared: NetworkUtility = NetworkUtility()
    private init() {}
    
    func performOperation<T:Decodable>(request: URLRequest, response: T.Type) async throws -> T{
        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)

            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                print(serverUrlResponse)
                      throw ApiError.nonSuccessStatusCode
                  }
            return try JSONDecoder().decode(response.self, from: serverData)

        } catch  {
            throw error
        }
    }
}

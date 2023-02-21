//
//  Authresponse.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 24/01/23.
//

import Foundation
struct AuthResource {
    func getToken() async throws -> AuthResponse {
        guard let url = Endpoint.getToken.url(for: .production) else{
            throw ApiError.invalidUrl
        }
        let urlRequest = URLRequest(url: url)
        do {
            return try await NetworkUtility.shared.performOperation(request: urlRequest, response: AuthResponse.self)
        } catch  {
            throw error
        }
    }
    
    func getUserRegistered(_ registrationRequest: RegistrationRequest) async throws -> RegisterationResponse{
        guard let url = Endpoint.registerUser.url(for: .production) else{
            throw ApiError.invalidUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = createRegistrationHTTPBody(registrationRequest)
        urlRequest.httpMethod = ApiMethod.post.Name
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            return try await NetworkUtility.shared.performOperation(request: urlRequest, response: RegisterationResponse.self)
        } catch  {
            throw error
        }
    }
    
    
    func loginUser(_ loginRequest: RegistrationRequest) async throws -> RegisterationResponse{
        guard let url = Endpoint.loginUser.url(for: .production) else{
            throw ApiError.invalidUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = createLoginHTTPBody(loginRequest)
        urlRequest.httpMethod = ApiMethod.post.Name
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        do {
            return try await NetworkUtility.shared.performOperation(request: urlRequest, response: RegisterationResponse.self)
        } catch  {
            throw error
        }
    }
    
    func createRegistrationHTTPBody(_ registrationrequest: RegistrationRequest) -> Data? {
        do {
            return try JSONEncoder().encode(registrationrequest)
        } catch  {
            debugPrint("error while encoding to data")
            return nil
        }
    }
    
    func createLoginHTTPBody(_ loginRequest: RegistrationRequest) -> Data?{
        let loginRequest = LoginRequest(UserEmail: loginRequest.Email, UserPassword: loginRequest.Password)
        do {
            return try JSONEncoder().encode(loginRequest)
        } catch  {
            debugPrint("error while encoding to data")
            return nil
        }
    }
}

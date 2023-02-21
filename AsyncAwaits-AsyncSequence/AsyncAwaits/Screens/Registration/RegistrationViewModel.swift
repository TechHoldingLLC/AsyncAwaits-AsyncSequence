//
//  RegistrationViewModel.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import Foundation

class RegistrationViewModel{
    private let authResource = AuthResource()
    
    func getUserRegistered(_ registartionRequest: RegistrationRequest) async throws -> RegisterationResponse? {
        do {
            return try await authResource.getUserRegistered(registartionRequest)
           // return try await authResource.loginUser(registartionRequest)

        } catch let serviceError {
            throw serviceError
        }
    }
}

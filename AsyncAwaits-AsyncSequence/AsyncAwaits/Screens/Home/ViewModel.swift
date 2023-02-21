//
//  ViewModel.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 23/01/23.
//

import Foundation


class HomeViewModel{
    
    private let authResource = AuthResource()
    private let employeeResource = EmployeeResource()
    private let userResource = UserResource()
    private let deviceResource = DeviceResource()
    
    var employeesspayroll: [EmployeePayroll] = []
    var users: [User] = []
    var device: [Device] = []

    func getPayroll() async throws -> [EmployeePayroll]? {
        do {
            let authResponse = try await authResource.getToken()
            return try await employeeResource.getPayroll(token: authResponse.token)

        } catch let serviceError {
            throw serviceError
        }
    }
    
    func getUsers() async throws -> [User]?{
        do {
            return try await userResource.getUsers()
        } catch let serviceError {
            throw serviceError
        }
    }
    
    func getDevices() async throws -> [Device]?{
        do {
            return try await deviceResource.getDevices()
        } catch let serviceError {
            throw serviceError
        }
    }
    
}

//
//  Path.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 23/01/23.
//

import Foundation

/* Set of Enums for different method types, different Enviornment, Api errors and Paths
 */


public enum Enviornment: Int {
    case production
    case sandbox
}

enum ApiError: Error {
    case unknownError
    case invalidUrl
    case nonSuccessStatusCode
}

enum ApiMethod: Int {
    case get
    case post
    case patch
    case delete
    case put
    
    var Name: String {
        switch self {
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        default:
            return "GET"
        }
    }
}

/* We can have more than one Endpoint enums same as we have separate resource for each
    domain.
 */

enum Endpoint {
    case getToken
    case getPayroll
    case registerUser
    case loginUser
    case getUsers
    case getDevices
    
    private var path: String {
        switch self {
        case .getToken:
            return "/Employee/GetToken"
        case .getPayroll:
            return "/Employee/GetEmployeePayroll"
        case .registerUser:
            return "/User/RegisterUser"
        case .loginUser:
            return "/User/Login"
        case .getUsers:
            return "/User/GetUser"
        case .getDevices:
            return "/Product/GetSmartPhone"
        }
    }
    
    func url(for host: Enviornment) -> URL? {
        let baseUrl = baseURLForEnviornment(host)
        return URL.init(string:"\(baseUrl)\(path)")
    }
    
    /* If we are using multiple enviornment
     */

    func baseURLForEnviornment(_ enviornment: Enviornment) -> URL{
        switch enviornment {
        case .production:
            return URL(string: "https://api-dev-scus-demo.azurewebsites.net/api")!
        case .sandbox:
            return URL(string: "")!
        }
    }
}
    



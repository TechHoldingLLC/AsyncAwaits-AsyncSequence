//
//  Auth.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 23/01/23.
//

import Foundation

struct AuthResponse : Codable {
    let token: String
}

struct RegisterationResponse: Codable{
    let name: String?
    let email: String?
    let id: String?
    let joining: String?
}

struct RegistrationRequest: Codable{
    let Name: String
    let Email: String
    let Password: String
}

struct LoginRequest: Codable{
    let UserEmail: String
    let UserPassword: String
}



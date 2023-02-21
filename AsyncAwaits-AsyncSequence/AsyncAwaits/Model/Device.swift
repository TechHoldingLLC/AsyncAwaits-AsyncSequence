//
//  Device.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import Foundation
struct DeviceResponse: Codable{
    let errorMessage: String?
    let data: [Device]?
}
struct Device: Codable{
    let name: String
    let operatingSystem: String
    let manufacturer: String
    let color: String
}

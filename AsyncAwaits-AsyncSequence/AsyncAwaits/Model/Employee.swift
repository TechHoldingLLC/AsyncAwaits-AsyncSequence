//
//  Employee.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 23/01/23.
//

import Foundation

struct PayrollResponse: Decodable {
    let errorMessage: String?
    let data: [EmployeePayroll]?
}

struct EmployeePayroll: Decodable {

    let employeeId: Int
    let name, countryCode, currencyCode: String
    let weeklyRate: Int

    enum CodingKeys: String, CodingKey {
        case employeeId
        case name, countryCode, currencyCode
        case weeklyRate
    }
}

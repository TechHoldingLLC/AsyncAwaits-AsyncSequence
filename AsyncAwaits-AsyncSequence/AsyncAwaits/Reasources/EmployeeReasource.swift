//
//  EmployeeReasource.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 24/01/23.
//

import Foundation
struct EmployeeResource {
    
    func getPayroll(token: String) async throws -> [EmployeePayroll] {
        // attaching token to the body
        guard let url = Endpoint.getPayroll.url(for: .production) else {
            throw ApiError.invalidUrl
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = createPayrollHttpBody(token: token)
        urlRequest.httpMethod = ApiMethod.post.Name
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        do {
            let serviceResponse = try await NetworkUtility.shared.performOperation(request: urlRequest, response: PayrollResponse.self)
            guard let empPayroll = serviceResponse.data else {
                    return []
            }
            return empPayroll
        } catch let serviceError {
            throw serviceError
        }
    }
    
    private func createPayrollHttpBody(token: String) -> Data? {
        let payrollBody = AuthResponse(token: token)
        do {
            return try JSONEncoder().encode(payrollBody)
        } catch  {
            debugPrint("error while encoding to data")
            return nil
        }
    }
}

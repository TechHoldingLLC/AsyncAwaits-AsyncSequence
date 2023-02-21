//
//  HttpUtility.swift
//
//  Created by Harish Suthar on 14/12/22.
//  Copyright © 2022 Techholding. All rights reserved.
//

import Foundation

final class HttpHelper {

    public enum HTTPMethod: String, Equatable {
        case connect = "CONNECT"
        case delete = "DELETE"
        case get = "GET"
        case head = "HEAD"
        case options = "OPTIONS"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case trace = "TRACE"
    }

    enum HttpError: LocalizedError, Equatable {
        case empty
        case failure(_ message: String? = nil)

        var errorDescription: String? {
            switch self {
                case .failure(let message):
                    return (message ?? "kDefaultError")
                default:
                    return "kDefaultError"
            }
        }
    }

    static let shared: HttpHelper = HttpHelper()

    private init() {
    }

    fileprivate func perform<T: Decodable>(request: URLRequest, response: T.Type, completion: @escaping (Result<(T?, Data?), Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (responseData, urlResponse, error) in
            // Check for error
            if error != nil {
                return completion(.failure(HttpError.failure()))
            }

            // Check if serverData is not empty
            guard let data = responseData, !data.isEmpty else {
                return completion(.failure(HttpError.empty))
            }

            // Check for http staus code
            guard let httpStausCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
                return completion(.failure(HttpError.failure()))
            }

            // Check for success staus codes
            guard (200...299).contains(httpStausCode) else {
                // Parse data to extract message
                var message: String?
                if let json = try? JSONDecoder().decode(JSON.self, from: data) {
                    if let value = json.object, let msg = value["message"] as? String{
                        message = msg
                    } else if let value = json.string {
                        message = value
                    }
                }

                return completion(.failure(HttpError.failure(message)))
            }

            // Decode the result
            do {
                let result = try JSONDecoder().decode(response.self, from: data)
                completion(.success((result, data)))
            } catch {
                completion(.failure(HttpError.failure()))
            }
        }.resume()
    }

    fileprivate func perform<T: Decodable>(request: URLRequest, response: T.Type) async throws -> (T, Data) {
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)

            // Check for http staus code
            guard let httpStausCode = (urlResponse as? HTTPURLResponse)?.statusCode else {
                throw HttpError.failure()
            }

            // Check for success staus codes
            guard (200...299).contains(httpStausCode) else {
                // Parse data to extract message
                var message: String?
                if let json = try? JSONDecoder().decode(JSON.self, from: data) {
                    if let value = json.dictionary, let msg = value["message"] as? String {
                        message = msg
                    } else if let value = json.string {
                        message = value
                    }
                }

                throw HttpError.failure(message)
            }

            // Decode the result
            let result = try JSONDecoder().decode(response.self, from: data)
            return (result, data)
        } catch {
            throw HttpError.failure()
        }
    }

    func perform(request: URLRequest, using asyncAwait: Bool = false, completion: @escaping (Any?, Data?, Error?) -> Void) {
        if let method = request.httpMethod, let url = request.url?.absoluteString {
            debugPrint("HTTP REQUEST URL => \(method):\(url)")
        }

        if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
            debugPrint("HTTP REQUEST BODY => \(body)")
        }

        if asyncAwait {
            Task {
                do {
                    let response = try await self.perform(request: request, response: JSON.self)
                    if let json = String(data: response.1, encoding: .utf8) {
                        debugPrint("HTTP RESPONSE => \(json)")
                    }

                    if let value = response.0.dictionary {
                        completion(value, response.1, nil)
                    } else if let value = response.0.array {
                        completion(value, response.1, nil)
                    } else {
                        completion(response.0, response.1, nil)
                    }
                } catch let error {
                    completion(nil, nil, error)
                }
            }
        } else {
            self.perform(request: request, response: JSON.self) { (result) in
                switch result {
                    case .success(let result):
                        if let data = result.1, let json = String(data: data, encoding: .utf8) {
                            debugPrint("HTTP RESPONSE => \(json)")
                        }

                        if let value = result.0?.dictionary {
                            completion(value, result.1, nil)
                        } else if let value = result.0?.array {
                            completion(value, result.1, nil)
                        } else {
                            completion(result.0, result.1, nil)
                        }
                    case .failure(let error):
                        completion(nil, nil, error)
                }
            }
        }
    }
}

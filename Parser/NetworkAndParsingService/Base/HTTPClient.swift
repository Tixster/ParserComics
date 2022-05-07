//
//  HTTPClient.swift
//  Parser
//
//  Created by Кирилл Тила on 07.05.2022.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(session: URLSession, endpoint: Endpoint, responseModel: T.Type) async -> Result<T, HTTPRequestError>
}

extension HTTPClient {
    
    func sendRequest<T: Decodable>(session: URLSession, endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, HTTPRequestError> {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            return .failure(.invalidURL)
        }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return await withCheckedContinuation { continuation in
            session.dataTask(with: request) { data, response, error in

                if let error = error {
                    continuation.resume(returning: .failure(.request(localizedDescription: error.localizedDescription)))
                }

                guard let responseCode = (response as? HTTPURLResponse)?.statusCode else {
                    return continuation.resume(returning: .failure(.noResponse))
                }

                switch responseCode {
                case 200...299:
                    if let data = data, let decodeResponse = try? JSONDecoder().decode(responseModel, from: data) {
                        continuation.resume(returning: .success(decodeResponse))
                    }
                    continuation.resume(returning: .failure(.decode))
                case 401:
                    continuation.resume(returning: .failure(.unauthorized))
                default:
                    continuation.resume(returning: .failure(.unexpectedStatusCode))
                }

            }
        }
    }
    
}

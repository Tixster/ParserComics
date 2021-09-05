//
//  NetworkService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation

protocol Networking {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService {
    
    let session = URLSession.shared
    
}

extension NetworkService: Networking {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            completion(.success(data))
        }
    }
    
    
}

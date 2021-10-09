//
//  NetworkService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation

protocol Networking {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func requestMangaTitle(url: URL, completion: @escaping(Result<MangaData, Error>) -> Void)
}

final class NetworkService {
    
    let session = URLSession.shared
    
}

extension NetworkService: Networking {
    func requestMangaTitle(url: URL, completion: @escaping (Result<MangaData, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? ParsingService.shared.fecthMangaList(url: url) {
                completion(.success(data))
            } else {
                completion(.failure(ParseError.mangaLinstIsNill("Тайтлы не найдены")))
            }
        }

    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let data = data else {
                    print("Нет данных")
                    return
                }
                completion(.success(data))
            }.resume()
        }
    }
    
    
}

//
//  NetworkService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation
import Network
import Combine

enum NetworkError: Error {
    case dontGetData(desc: String)
    case customError(desc: String)
}

protocol Networking {
    func request(url: URL) async throws -> Data
    func requestMangaTitle(url: URL) async throws -> MangaData
}

final class NetworkService {
    
    let session = URLSession.shared
    let monitor = NWPathMonitor()
    var store: Set<AnyCancellable> = []
    
}

extension NetworkService: Networking {

    func requestMangaTitle(url: URL) async throws -> MangaData {
        try await ParsingService.fecthMangaList(url: url)
    }
    
    func request(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            _ = session.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ data, response -> Data in
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        throw NetworkError.dontGetData(desc: "Ошибка HTTP: \(httpResponse.statusCode)")
                    }
                    return data
                })
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        return
                    }
                } receiveValue: { data in
                    print(Thread.isMainThread)
                    continuation.resume(returning: data)
                }
        }
    }
    
}

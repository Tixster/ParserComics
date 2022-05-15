//
//  NetworkService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation

enum NetworkError: Error {
    case dontGetData(desc: String)
    case customError(desc: String)
}

protocol Networking {
    func requestMangaTitle(url: URL) async throws -> MangaData
}

final class NetworkService {
    
    let session = URLSession.shared
    
}

extension NetworkService: Networking {

    func requestMangaTitle(url: URL) async throws -> MangaData {
        try await ParsingService.fecthMangaList(url: url)
    }
    
}

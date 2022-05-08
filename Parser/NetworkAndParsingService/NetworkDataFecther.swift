//
//  NetworkDataFecther.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation
import UIKit

protocol DataFetcher {
    func getMangaList(url: URL) async throws -> MangaData
}

struct NetworkDataFecther: DataFetcher, HTTPClient {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getMangaList(url: URL) async throws -> MangaData {
        return try await networking.requestMangaTitle(url: url)
    }

}


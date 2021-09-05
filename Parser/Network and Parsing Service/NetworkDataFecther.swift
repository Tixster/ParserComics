//
//  NetworkDataFecther.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation
import UIKit

protocol DataFetcher {
    func getHTML(response: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkDataFecther: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getHTML(response: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://hentaichan.live/manga/new") else {
            print("URL не валидный")
            return
        }
        networking.request(url: url) { result in
            switch result {
            case .failure(let error):
                response(.failure(error))
            case .success(let data):
                response(.success(data))
            }
        
        }
    }
    
}

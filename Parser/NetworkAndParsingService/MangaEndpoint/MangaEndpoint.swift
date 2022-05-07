//
//  MangaEndpoint.swift
//  Parser
//
//  Created by Кирилл Тила on 07.05.2022.
//

import Foundation

enum MangaEndpoint {
    case newManga
}

extension MangaEndpoint: Endpoint {
    var path: String {
        switch self {
        case .newManga: return "manga/new"
        }
    }

    var method: HTTTPRequestMethod {
        switch self {
        case .newManga: return .get
        }
    }

    var header: [String : String]? {
        switch self {
        case .newManga: return nil
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .newManga: return nil
        }
    }

}

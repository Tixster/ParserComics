//
//  HTTPRequestError.swift
//  Parser
//
//  Created by Кирилл Тила on 07.05.2022.
//

enum HTTPRequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case request(localizedDescription: String)
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var message: String {
        switch self {
        case .decode:
            return "Ошибка декдоирования"
        case .invalidURL:
            return "Неверный URL"
        case .noResponse:
            return "Нет ответа"
        case .unauthorized:
            return "Сессия окончена"
        case .unexpectedStatusCode:
            return "unexpectedStatusCode"
        case .unknown:
            return "Unknown error"
        case .request(let localizedDescription):
            return localizedDescription
        }
    }
    
}

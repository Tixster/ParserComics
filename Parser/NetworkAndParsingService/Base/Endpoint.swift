//
//  Endpoint.swift
//  Parser
//
//  Created by Кирилл Тила on 07.05.2022.
//

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTTPRequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var baseURL: String {
        return Constants.SiteLinks.siteMainPageURL
    }
}

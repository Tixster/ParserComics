//
//  MainParserWorker.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserServiceLogic: AnyObject {
    func getMangaTitle(with endpoint: String) async throws -> MangaData
    func getNextPangeMangaTitles() async throws -> MangaData
}

class MainParserService: MainParserServiceLogic {
    
    private var fetcher: DataFetcher = NetworkDataFecther(networking: NetworkService())
    private var nextPageURL: URL?

    func getMangaTitle(with endpoint: String) async throws -> MangaData {
        let url: URL = .init(string: Constants.SiteLinks.siteMainPageURL + endpoint)!
        let data = try await getMangaData(with: url)
        return data
    }
    
    func getNextPangeMangaTitles() async throws -> MangaData {
        guard let nextPage = nextPageURL else {
            throw NetworkError.customError(desc: "Нет следующей страницы")
        }
        let data = try await getMangaData(with: nextPage)
        return data
    }
}

private extension MainParserService {
    func getMangaData(with url: URL) async throws -> MangaData {
        let data = try await fetcher.getMangaList(url: url)
        self.nextPageURL = data.nextPage
        return data
    }
}

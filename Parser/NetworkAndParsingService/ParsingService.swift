//
//  ParsingService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation
import ParserComics
import UIKit

final class ParsingService {

    static let parser: ParserComics = .init(base: URL(string: Constants.SiteLinks.siteMainPageURL)!)
    
    private static var session: URLSession = .shared
    /// Получение списка тайтлов
    static func fecthMangaList(url: URL) async throws -> MangaData {
        do {
            let data = try await parser.fecthMangaList(url: url)
            let mangaData: MangaData = .init(titles: data.titles, nextPage: data.nextPage)
            return mangaData
        } catch let error {
            throw error
        }

    }

    /// Получение следующей страницы с тайтлами
    static func fetchNextPageTitles(url: URL) async throws -> MangaData? {
        guard let data = try await parser.fetchNextPageTitles(url: url) else { return nil }
        let mangaData: MangaData = .init(titles: data.titles, nextPage: data.nextPage)
        return mangaData
    }

    /**
     Получение ссылок на сканы
     - parameter url: Ссылка на вкладку, октрывающую читалку со страницами.
     - returns: Возвращает массив ссылок на сканы из главы
     */
    static func fetchMangaPagesLink(url: URL) -> [URL]? {
        parser.fetchMangaPagesLink(url: url)
    }

}


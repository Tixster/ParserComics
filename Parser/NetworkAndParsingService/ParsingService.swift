//
//  ParsingService.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//

import Foundation
import SwiftSoup
import UIKit

enum ParseError: Error {
    case linksPageIsNill(String)
    case mangaLinstIsNill(String)
}

class ParsingService {
    
    static let shared = ParsingService()
    
    private init() {}
    
    /// Получение списка тайтлов
    func fecthMangaList(url: URL) throws -> MangaData {
        let html = try String(contentsOf: url, encoding: .utf8)
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let content = try doc.select("div[id=content]")
            let titleCount = try content.select("div.content_row")
            var curTitles = [TitleModel]()
            for curTitle in titleCount {
                let titleManga = try curTitle.select("a.title_link").text()
                let coverManga = try curTitle.select("div.manga_images img").attr("src")
                let descriptionManga = try curTitle.select("div.tags").text()
                let author = try curTitle.select("h3.item2").text()
                let titleLink = try curTitle.select("a").attr("href")
                let titleInfo = try curTitle.select("div.row4_left").text()
                let likes = titleInfo.getNumbers(pattern: "\\d+(?=\\s*плюсик)")
                let views = titleInfo.getNumbers(pattern: "\\d+(?=\\s*просмотр)")
                let pages = titleInfo.getNumbers(pattern: "\\d+(?=\\s*страниц)")
                let originalBlurCover = coverManga.replacingOccurrences(of: "_thumbs_blur\\w*", with: "", options: [.regularExpression])
                let originalCover = originalBlurCover.replacingOccurrences(of: "_thumbs\\w*", with: "", options: [.regularExpression])
                curTitles.append(TitleModel(title: titleManga,
                                            cover: URL(string: originalCover)!,
                                            description: descriptionManga,
                                            author: author,
                                            link: URL(string: Constants.SiteLinks.siteMainPageURL + titleLink)!,
                                            likes: likes,
                                            views: views,
                                            pages: pages))
            }
            let nextPage = try doc.select("div[id=pagination] a:contains(Вперед)").attr("href")
            let mangaData = MangaData(titles: curTitles, nextPage: URL(string: Constants.SiteLinks.siteNewMangaPageURL + nextPage)!)
            return mangaData
        } catch Exception.Error(type: let type, Message: let message){
            print("type: \(type), message: \(message)")
        } catch {
            print(error.localizedDescription)
        }
        throw ParseError.mangaLinstIsNill("Список манги пустой")
    }
    
    /// Получение следующей страницы с тайтлами
    func fetchNextPageTitles(url: URL) -> MangaData? {
        return try? fecthMangaList(url: url)
    }
    
    func fecthDetailTitleInfo(for url: URL) {
        
    }
    
    /**
     Получение ссылок на скнаы
     - parameter url: Ссылка на вкладку, октрывающую читалку со страницами.
     - returns: Возвращает массив ссылок на сканы из главы
     */
    func fetchMangaPagesLink(url: URL) -> [URL]? {
        let html = try! String(contentsOf: url, encoding: .utf8)
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let urlReader = try doc.select("div[id=manga_images] a").attr("href")
            print("Manga Pages Link: \(urlReader)")
            if let url = URL(string: urlReader) {
                return try fetchPagesLink(url: url)
            }
        } catch Exception.Error(type: let type, Message: let message){
            print("type: \(type), message: \(message)")
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// Получение ссылок на страницы из манги по ссылке со страницы тайтла
    private func fetchPagesLink(url: URL) throws -> [URL] {
        let html = try! String(contentsOf: url, encoding: .utf8)
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let shtml = try doc.getElementsByTag("script").get(2).outerHtml()
            
            let pattern = #"\{[\w\W]+?"fullimg":\s*(\[[^\]]+\])\s*\}"#
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            if let match = regex?.firstMatch(in:  shtml, options: [], range: NSRange(location: 0, length: shtml.utf16.count)) {
                if let links = Range(match.range(at: 1), in: shtml) {
                    let link = String(shtml[links])
                    let linksArray = link.replacingOccurrences(of: "[\'\\[\\]]",
                                                               with: "",
                                                               options: [.regularExpression, .caseInsensitive])
                        .components(separatedBy: ", ")
                        .compactMap { URL(string: $0) }
                    return linksArray
                }
            }
        } catch Exception.Error(type: let type, Message: let message) {
            print("type: \(type), message: \(message)")
        } catch {
            print(error.localizedDescription)
        }
        throw ParseError.linksPageIsNill("Ссылки на страницы не найдены")
    }
    
}


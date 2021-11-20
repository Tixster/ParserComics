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
    
    private init() {
        
    }
    
    // Получение списка тайтлов
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
                let originalBlurCover = coverManga.replacingOccurrences(of: "_thumbs_blur\\w*", with: "", options: [.regularExpression])
                let originalCover = originalBlurCover.replacingOccurrences(of: "_thumbs\\w*", with: "", options: [.regularExpression])
                curTitles.append(TitleModel(title: titleManga,
                                            cover: URL(string: originalCover)!,
                                            description: descriptionManga,
                                            author: author,
                                            link: URL(string: Constants.SiteLinks.siteMainPageURL + titleLink)!))
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
    
    // Получение следующей страницы с тайтлами
    func fetchNextPageTitles(url: URL) -> MangaData? {
        return try? fecthMangaList(url: url)
    }
    
    // Получение ссылки на страницу с содержимым манги
    func fetchMangaPagesLink(url: URL) {
        let html = try! String(contentsOf: url, encoding: .utf8)
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let nextPage = try doc.select("div[id=manga_images] a").attr("href")
            print("Manga Pages Link: \(nextPage)")
        } catch Exception.Error(type: let type, Message: let message){
            print("type: \(type), message: \(message)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Получение ссылок на страницы манги
    func fetchPagesLink(url: URL) throws -> [URL?] {
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
                        .map { URL(string: $0) }
                    
                    
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

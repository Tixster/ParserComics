//
//  Constants.swift
//  Parser
//
//  Created by Кирилл Тила on 16.11.2021.
//

import UIKit

struct Constants {
    
    /// Ссылки сайтов для парсинга
    struct SiteLinks {
        static var siteMainPageURL: String {
            get {
                if let text = UserDefaults.standard.string(forKey: "siteMangaPage") {
                    return text
                }
                return "https://xxxx.hentaichan.live"
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "siteMangaPage")
            }
        }
    }
    
    /// Размеры таблицы главного экрана
    struct MainTableView {
        static let heightTableViewMangaCell: CGFloat = UIScreen.main.bounds.height * 0.21
        static let widthTableViewMangaCell: CGFloat = UIScreen.main.bounds.width - ((UIScreen.main.bounds.width * 0.026) * 2)
        static let heightCoverTableCell: CGFloat = heightTableViewMangaCell
        static let widthCoverTableCell: CGFloat = widthTableViewMangaCell * 0.26
    }
    
    /// Размеры коллекции главного экрана
    struct MainCollectionView {
        
        static let width = UIScreen.main.bounds.size.width - 3 * CGFloat(2 - 1)
        static let itemSize = CGSize(width: floor(width / 2) - 5, height: (width / 2) * 1.4)
        
    }
    
}

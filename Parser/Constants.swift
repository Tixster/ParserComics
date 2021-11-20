//
//  Constants.swift
//  Parser
//
//  Created by Кирилл Тила on 16.11.2021.
//

import UIKit

struct Constants {
    
    struct SiteLinks {
        static let siteMainPageURL = "https://hentaichan.live"
        static let siteNewMangaPageURL = "https://hentaichan.live/manga/new"
    }
    
    struct MainTableView {
        static let heightTableViewMangaCell: CGFloat = UIScreen.main.bounds.height * 0.21
        static let widthTableViewMangaCell: CGFloat = UIScreen.main.bounds.width - ((UIScreen.main.bounds.width * 0.026) * 2)
        static let heightCoverTableCell: CGFloat = heightTableViewMangaCell
        static let widthCoverTableCell: CGFloat = widthTableViewMangaCell * 0.26
    }
    
    struct MainCollectionView {
        
        static let width = UIScreen.main.bounds.size.width - 3 * CGFloat(2 - 1)
        static let itemSize = CGSize(width: floor(width / 2) - 5, height: (width / 2) * 1.4)
        
    }
    
}

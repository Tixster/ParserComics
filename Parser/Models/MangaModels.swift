//
//  MangaModels.swift
//  Parser
//
//  Created by Кирилл Тила on 25.09.2021.
//

import Foundation
import UIKit

struct MangaData {
    let titles: [TitleModel]
    let nextPage: URL
}

struct Manga {
    var lists: [MangaData]
    var manga: [TitleModel]
}

struct TitleModel: Codable {
    let title: String
    let cover: URL
    let description: String?
    let author: String
    let link: URL
    let likes: Int
    let views: Int
    let pages: Int
}


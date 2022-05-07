//
//  MainParserModels.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum MainParser {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewMangaList
        case getPopularMangaList
        case getNextMangaList
        case getMostDownloadsMangaList
        case getMostViewsMangaList
      }
    }
    struct Response {
      enum ResponseType {
        case presentMangaData(MangaData, Bool)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case displayMangaData([TitleModel])

      }
    }
  }
}

extension MainParser.Model.Request.RequestType {
    
    var endpoint: SortType {
        switch self {
        case .getNewMangaList: return .new
        case .getNextMangaList: return .none
        case .getPopularMangaList: return .popular
        case .getMostDownloadsMangaList: return .download
        case .getMostViewsMangaList: return .views
        }
    }
    
}

enum SortType: String {
    case new = "manga/new"
    case popular = "mostfavorites&sort=manga"
    case download = "mostdownloads&sort=manga"
    case views = "mostviews&sort=manga"
    case none
    
    var title: String {
        switch self {
        case .new: return "Новая манга"
        case .popular: return "Популярное"
        case .download: return "Загружаемое"
        case .views: return "Просматриваемое"
        case .none: return ""
        }
    }
    
    var requestType: MainParser.Model.Request.RequestType {
        switch self {
        case .new: return .getNewMangaList
        case .popular: return .getPopularMangaList
        case .download: return .getMostDownloadsMangaList
        case .views: return .getMostViewsMangaList
        case .none: return .getNewMangaList
        }
    }
    
}

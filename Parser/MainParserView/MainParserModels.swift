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
        case getMangaList
        case getNextMangaList
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


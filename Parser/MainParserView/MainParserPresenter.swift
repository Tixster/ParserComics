//
//  MainParserPresenter.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserPresentationLogic {
  func presentData(response: MainParser.Model.Response.ResponseType)
}

class MainParserPresenter: MainParserPresentationLogic {
  weak var viewController: MainParserDisplayLogic?
    var mangaDataLists = [TitleModel]()
  
  func presentData(response: MainParser.Model.Response.ResponseType) {
    switch response {
    case .presentMangaData(let mangaData, let isFirstPage):
        if isFirstPage {
            mangaDataLists.removeAll()
        }
        let _ = mangaData.titles.map { manga in
            mangaDataLists.append(manga)
        }
        
        viewController?.displayData(viewModel: .displayMangaData(mangaDataLists))
    case .presentFooterLoader:
        viewController?.displayData(viewModel: .displayFooterLoaerd)
    }
  }
  
}

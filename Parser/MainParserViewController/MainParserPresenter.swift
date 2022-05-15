//
//  MainParserPresenter.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine
protocol MainParserPresentationLogic {
    func presentData(response: MainParser.Model.Response.ResponseType)
    var mangaDataLists: [TitleModel] { get set }
}

class MainParserPresenter: MainParserPresentationLogic {
    weak var viewController: MainParserDisplayLogic?
    var mangaDataLists = [TitleModel]()
    
    init() {
    
    }
    
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
        }
    }
    
}

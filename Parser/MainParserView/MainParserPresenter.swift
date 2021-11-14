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
        let jsonData = try! JSONEncoder().encode(mangaDataLists)
        let decodeModel = try! JSONDecoder().decode([TitleModel].self, from: jsonData)
        print(decodeModel[0].link, decodeModel[0].title)
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataURL = documentDirectory.appendingPathComponent("MangaModelJSON")
        do {
            try FileManager.default.createDirectory(atPath: dataURL.path, withIntermediateDirectories: true, attributes: nil)
            let fileUrl = dataURL.appendingPathComponent("mangaList.json")
            try jsonData.write(to: fileUrl)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        viewController?.displayData(viewModel: .displayMangaData(mangaDataLists))
    }
  }
  
}

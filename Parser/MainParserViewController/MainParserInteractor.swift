//
//  MainParserInteractor.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserBusinessLogic {
    func makeRequest(request: MainParser.Model.Request.RequestType) async
}

class MainParserInteractor: MainParserBusinessLogic {
    
    var presenter: MainParserPresentationLogic?
    var service: MainParserServiceLogic?
    
    func makeRequest(request: MainParser.Model.Request.RequestType) async  {
        if service == nil {
            service = MainParserService()
        }

        Task { [weak self] in
            print(Thread.isMainThread)
            switch request {
            case .getNewMangaList, .getPopularMangaList, .getMostDownloadsMangaList, .getMostViewsMangaList:
                if let mangaData = try? await self?.service?.getMangaTitle(with: request.endpoint.rawValue) {
                    self?.presenter?.presentData(response: .presentMangaData(mangaData, true))
                }
            case .getNextMangaList:
                if let nextMangaData = try? await self?.service?.getNextPangeMangaTitles() {
                    self?.presenter?.presentData(response: .presentMangaData(nextMangaData, false))
                }
            }
        }
    }
    
}

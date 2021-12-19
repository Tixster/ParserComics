//
//  MainParserInteractor.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserBusinessLogic {
    func makeRequest(request: MainParser.Model.Request.RequestType)
}

class MainParserInteractor: MainParserBusinessLogic {
    
    var presenter: MainParserPresentationLogic?
    var service: MainParserServiceLogic?
    
    func makeRequest(request: MainParser.Model.Request.RequestType) {
        if service == nil {
            service = MainParserService()
        }
        
        switch request {
        case .getMangaList:
            service?.getMangaTitle(url:  URL(string: Constants.SiteLinks.siteNewMangaPageURL)!) { [weak self] data in
                self?.presenter?.presentData(response: .presentMangaData(data,true))
            }
        case .getNextMangaList:
            service?.getNextPangeMangaTitles(completion: { mangaData in
                self.presenter?.presentData(response: .presentMangaData(mangaData, false))
            })
        }
        
    }
    
}

//
//  MainParserInteractor.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserBusinessLogic {
    func makeRequest(request: MainParser.Model.Request.RequestType) async throws
}

class MainParserInteractor: MainParserBusinessLogic {
    
    var presenter: MainParserPresentationLogic?
    var service: MainParserServiceLogic?
    
    func makeRequest(request: MainParser.Model.Request.RequestType) async throws  {
        if service == nil {
            service = MainParserService()
        }
        
        Task { [unowned self] in
            switch request {
            case .getNewMangaList, .getPopularMangaList, .getMostDownloadsMangaList, .getMostViewsMangaList:
                do {
                    let mangaData = try await self.service!.getMangaTitle(with: request.endpoint.rawValue)
                    self.presenter!.presentData(response: .presentMangaData(mangaData, true))
                } catch {
                    AlertManager.errorAlert(with: error, okHandler: { [weak self] _ in
                        self?.showEditLinkAlert(with: request)
                    }, secondButton: AlertManager.addChangeMangaLinkAction { [weak self] in
                        self?.showEditLinkAlert(with: request)
                    })
                }
                
            case .getNextMangaList:
                do {
                    let nextMangaData = try await self.service!.getNextPangeMangaTitles()
                    self.presenter!.presentData(response: .presentMangaData(nextMangaData, false))
                } catch {
                    AlertManager.errorAlert(with: error, okHandler: { [weak self] _ in
                        self?.showEditLinkAlert(with: request)
                    }, secondButton: AlertManager.addChangeMangaLinkAction { [weak self] in
                        self?.showEditLinkAlert(with: request)
                    })
                }
            }
            
        }
    }
    
}

private extension MainParserInteractor {
    
    func showEditLinkAlert(with request: MainParser.Model.Request.RequestType) {
        AlertManager.editLinkAlert { [weak self] in
            guard let strongSelf = self else { return }
            Task {
                try? await strongSelf.makeRequest(request: request)
            }
        }
    }
    
}

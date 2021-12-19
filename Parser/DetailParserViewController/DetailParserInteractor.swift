//
//  DetailParserInteractor.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import Foundation

protocol DetailParserInteractorLogic {
    func makeRequest(request: DetailParser.Model.Request.RequestType)
}

class DetailParserInteractor: DetailParserInteractorLogic {
    
    var presenter: DetailParserPresentationLogic?
    var worker: DetailParserWorkerLogic?
    
    func makeRequest(request: DetailParser.Model.Request.RequestType) {
        if worker == nil {
            worker = DetailParserWorker()
        }
        
        switch request {
            
        case .getDetailTitle:
            return //presenter?.presentData(response: .presentDetailTitle(<#T##TitleModel#>))
        }
        
    }
    
}

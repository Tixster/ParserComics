//
//  DetailParserPresenter.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import Foundation

protocol DetailParserPresentationLogic {
    func presentData(response: DetailParser.Model.Response.ResponseType)
}

class DetailParserPresenter: DetailParserPresentationLogic {
    
    weak var viewController: DetailParserDisplayLogic?
    
    func presentData(response: DetailParser.Model.Response.ResponseType) {
        
    }
    
}

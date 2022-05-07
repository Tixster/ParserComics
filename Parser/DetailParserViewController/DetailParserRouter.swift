//
//  DetailParserRouter.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import Foundation

protocol DetailParserRouterLogic {
    func openReader()
}

class DetailPareserRouter: NSObject, DetailParserRouterLogic {

    
    weak var viewController: DetailParserViewController?
    
    func openReader() {
        
    }
    
    
}

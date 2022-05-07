//
//  MainParserRouter.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MainParserRoutingLogic {

    func openDetailMangaController()
    
}

class MainParserRouter: NSObject, MainParserRoutingLogic {

  weak var viewController: MainParserViewController?
  
  // MARK: Routing
    func openDetailMangaController() {

    }
  
}

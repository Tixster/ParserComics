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
  
  func presentData(response: MainParser.Model.Response.ResponseType) {
  
  }
  
}

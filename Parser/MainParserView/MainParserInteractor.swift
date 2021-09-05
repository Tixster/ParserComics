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
  var service: MainParserService?
  
  func makeRequest(request: MainParser.Model.Request.RequestType) {
    if service == nil {
      service = MainParserService()
    }
  }
  
}

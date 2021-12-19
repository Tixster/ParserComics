//
//  DetailParserWorker.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import Foundation

protocol DetailParserWorkerLogic {
    
}

class DetailParserWorker: DetailParserWorkerLogic {
    
    private var fetcher: DataFetcher = NetworkDataFecther(networking: NetworkService())
    
}

//
//  MainParserWorker.swift
//  Parser
//
//  Created by Кирилл Тила on 05.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class MainParserService {
    
    private var fetcher: DataFetcher = NetworkDataFecther(networking: NetworkService())
    private var nextPage: URL?
    
    func getHTML(completion: @escaping (Data) -> Void) {
        fetcher.getHTML { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                completion(data)
            }
        }
    }
    
    func getMangaTitle(url: URL, completion: @escaping(MangaData) -> Void) {
        
        fetcher.getMangaList(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.nextPage = data.nextPage
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getNextPangeMangaTitles(completion: @escaping(MangaData) -> Void) {
        guard let nextPage = nextPage else {
            return
        }
        
        getMangaTitle(url: nextPage) { [weak self] mangaData in
            guard let self = self else { return }
            self.nextPage = mangaData.nextPage
            completion(mangaData)
        }
    }
    
    
}

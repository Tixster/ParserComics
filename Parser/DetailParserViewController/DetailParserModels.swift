//
//  DetailParserModels.swift
//  Parser
//
//  Created by Кирилл Тила on 19.12.2021.
//

import Foundation

enum DetailParser {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getDetailTitle
            }
        }
        struct Response {
            enum ResponseType {
                case presentDetailTitle(TitleModel)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayDetailTitle(TitleModel)
            }
        }
    }
    
}

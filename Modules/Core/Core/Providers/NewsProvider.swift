//
//  NewsProvider.swift
//  Core
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Moya

enum NewsProvider {
    case getNewsTopHeadlines(country: String, category: String, page: Int, apiKey: String)
}

extension NewsProvider: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }

    var path: String {
        switch self {
        case .getNewsTopHeadlines:
            return "/top-headlines"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getNewsTopHeadlines(let country, let category, let page, let apiKey):
            return .requestParameters(parameters:
                                        [
                                            "country": country,
                                            "category": category,
                                            "page": page,
                                            "apiKey": apiKey
                                        ], 
                                      encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

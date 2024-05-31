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
        return URL(string: "https://gist.githubusercontent.com/zhocker")!
//        return URL(string: "https://newsapi.org/v2")!
    }
//https://gist.githubusercontent.com/zhocker/fea7802f7201b9cf000a06ac505a1f01/raw/ef74cd9052b5a605096bd3fc0ae584d044decbee/news.json
    var path: String {
        switch self {
        case .getNewsTopHeadlines:
            return "/fea7802f7201b9cf000a06ac505a1f01/raw/ef74cd9052b5a605096bd3fc0ae584d044decbee/news.json"
//            return "/top-headlines"
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
            return .requestParameters(parameters:[:], encoding: URLEncoding.default)

//            return .requestParameters(parameters:
//                                        [
//                                            "country": country,
//                                            "category": category,
//                                            "page": page,
//                                            "apiKey": apiKey
//                                        ], 
//                                      encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

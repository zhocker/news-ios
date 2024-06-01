//
//  NewsProvider.swift
//  Core
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Moya

public enum NewsProvider {
    case getNewsTopHeadlines(country: String, category: String, page: Int, query: String)
}

extension NewsProvider: TargetType {
    
    public var baseURL: URL {
//        return URL(string: "https://gist.githubusercontent.com/zhocker")!
        return URL(string: "https://newsapi.org/v2")!
    }

    public var path: String {
        switch self {
        case .getNewsTopHeadlines:
//            return "/fea7802f7201b9cf000a06ac505a1f01/raw/ef74cd9052b5a605096bd3fc0ae584d044decbee/news.json"
            return "/top-headlines"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .getNewsTopHeadlines(let country, let category, let page, let query):
//            return .requestParameters(parameters:[:], encoding: URLEncoding.default)
//
            return .requestParameters(parameters:
                                        [
                                            "country": country,
                                            "category": category,
                                            "page": page,
                                            "q": query
                                        ],
                                      encoding: URLEncoding.default)
        }
    }

    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

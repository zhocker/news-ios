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
        return URL(string: "https://newsapi.org/v2")!
    }

    public var path: String {
        switch self {
        case .getNewsTopHeadlines:
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
            return .requestParameters(parameters:
                                        [
                                            "country": country,
                                            "category": category,
                                            "page": page,
                                            "q": query,
                                            "apiKey" : "afa0965c2de04bbcaa8617b67b2fe890"
                                        ],
                                      encoding: URLEncoding.default)
        }
    }

    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

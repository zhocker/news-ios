//
//  NewsService.swift
//  Core
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Moya
import Combine

public protocol NewsServiceType {
    func getNews(page: Int, query: String) -> AnyPublisher<NewsResponse, Error>
}

public class NewsService: NewsServiceType {
    
    public let provider = MoyaProvider<NewsProvider>()
    public init() {
        
    }
    public func getNews(page: Int, query: String) -> AnyPublisher<NewsResponse, Error> {
        let endpoint = NewsProvider.getNewsTopHeadlines(country: "us", category: "business", page: page, query: query)
        let type = NewsResponse.self
        return provider.requestPublisher(endpoint, type: type)
    }
    
}

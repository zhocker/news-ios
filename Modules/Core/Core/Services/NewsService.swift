//
//  NewsService.swift
//  Core
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Moya
import Combine

protocol NewsServiceType {
    func getNews(page: Int, query: String) -> AnyPublisher<NewsResponse, Error>
}

class NewsService: NewsServiceType {
    
    private let provider = MoyaProvider<NewsProvider>()
    
    func getNews(page: Int, query: String) -> AnyPublisher<NewsResponse, Error> {
        let endpoint = NewsProvider.getNewsTopHeadlines(country: "us", category: "business", page: 1, query: query)
        let type = NewsResponse.self
        return provider.requestPublisher(endpoint, type: type)
    }
    
}

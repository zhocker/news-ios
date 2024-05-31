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
    func getNews(page: Int) -> AnyPublisher<NewsResponse, Error>
}

class NewsService: NewsServiceType {
    
    private let provider = MoyaProvider<NewsProvider>()
    
    func getNews(page: Int) -> AnyPublisher<NewsResponse, Error> {
        let endpoint = NewsProvider.getNewsTopHeadlines(country: "us", category: "business", page: 1, apiKey: "afa0965c2de04bbcaa8617b67b2fe890")
        let type = NewsResponse.self
        return provider.requestPublisher(endpoint, type: type)
    }
    
}

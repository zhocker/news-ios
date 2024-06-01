//
//  NewsListViewModel.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Combine
import Moya
import Core

class NewsListViewModel {
    
    enum Input {
        case viewDidLoad
        case search(String)
        case loadMore
    }

    enum Output {
        case fetchArticlesDidSucceed(articles: [Article])
        case fetchArticlesDidFail(error: Error)
        case toggleLoading(isLoading: Bool)
    }

    // Injected dependencies
    private let newsService: NewsServiceType
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var articles: [Article] = []
    private(set) var currentPage = 1
    private(set) var isLastPage = false
    private(set) var currentQuery = ""
    private(set) var isLoading = false

    // Dependency injection via initializer
    public init(newsService: NewsServiceType = NewsService()) {
        self.newsService = newsService
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] event in
                self?.handleInput(event)
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func handleInput(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchTopHeadlines(reset: true)
        case .search(let query):
            currentQuery = query
            searchHeadlines(query: query, reset: true)
        case .loadMore:
            if currentQuery.isEmpty {
                fetchTopHeadlines(reset: false)
            } else {
                searchHeadlines(query: currentQuery, reset: false)
            }
        }
    }

    private func fetchTopHeadlines(reset: Bool) {
        requestArticles(query: "", reset: reset)
    }

    private func searchHeadlines(query: String, reset: Bool) {
        requestArticles(query: query, reset: reset)
    }

    private func requestArticles(query: String, reset: Bool) {
        guard !isLoading, !isLastPage || reset else { return }

        if reset {
            currentPage = 1
            isLastPage = false
            articles.removeAll()
        } else {
            currentPage += 1
        }

        isLoading = true
        output.send(.toggleLoading(isLoading: true))

        newsService.getNews(page: currentPage, query: query)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                self?.output.send(.toggleLoading(isLoading: false))
                if case let .failure(error) = completion {
                    self?.output.send(.fetchArticlesDidFail(error: error))
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.handleSuccess(response)
            })
            .store(in: &cancellables)
    }

    private func handleSuccess(_ response: NewsResponse) {
        if response.articles.isEmpty {
            isLastPage = true
        } else {
            articles.append(contentsOf: response.articles)
            output.send(.fetchArticlesDidSucceed(articles: articles))
        }
    }
}

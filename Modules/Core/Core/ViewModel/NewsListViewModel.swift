//
//  NewsListViewModel.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Combine
import Moya

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

    private let provider = MoyaProvider<NewsProvider>()
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    private var isLastPage: Bool = false
    private var currentQuery: String = ""
    private var isLoading: Bool = false

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            self?.handleInput(event)
        }.store(in: &cancellables)
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
        requestArticles(endpoint: .getNewsTopHeadlines(country: "us", category: "business", page: currentPage, apiKey: "afa0965c2de04bbcaa8617b67b2fe890"), 
                        reset: reset)
    }

    private func searchHeadlines(query: String, reset: Bool) {
        // Assuming that the API call for search might be different, this is an example.
        // If it is the same as fetchTopHeadlines, direct the call to fetchTopHeadlines
        requestArticles(endpoint: .getNewsTopHeadlines(country: "us", 
                                                       category: "business",
                                                       page: currentPage,
                                                       apiKey: "afa0965c2de04bbcaa8617b67b2fe890"), 
                        reset: reset)
    }

    private func requestArticles(endpoint: NewsProvider, reset: Bool) {
        guard !isLoading else { return }

        if reset {
            currentPage = 1
            isLastPage = false
        } else {
            guard !isLastPage else { return }
            currentPage += 1
        }

        isLoading = true
        output.send(.toggleLoading(isLoading: true))

        provider.requestPublisher(endpoint, type: NewsResponse.self)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                self?.output.send(.toggleLoading(isLoading: false))

                if case let .failure(error) = completion {
                    self?.output.send(.fetchArticlesDidFail(error: error))
                }
            }, receiveValue: { [weak self] response in
                self?.handleSuccess(response: response)
            })
            .store(in: &cancellables)    }

    private func decodeResponse(response: Response) throws -> NewsResponse {
        guard (200...299).contains(response.statusCode) else {
            throw MoyaError.statusCode(response)
        }
        return try JSONDecoder().decode(NewsResponse.self, from: response.data)
    }

    private func handleError(error: Error) -> AnyPublisher<NewsResponse, Never> {
        output.send(.fetchArticlesDidFail(error: error))
        return Empty().eraseToAnyPublisher()
    }

    private func handleSuccess(response: NewsResponse) {
        if response.articles.isEmpty {
            isLastPage = true
        }
        output.send(.fetchArticlesDidSucceed(articles: response.articles))
    }
    
}

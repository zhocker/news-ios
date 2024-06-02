//
//  NewsListViewModelTests.swift
//  NewsTests
//
//  Created by User on 1/6/2567 BE.
//

import XCTest
import Combine
import Core
@testable import News

class NewsListViewModelTests: XCTestCase {
    
    private var viewModel: NewsListViewModel!
    private var newsServiceMock: NewsServiceMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        newsServiceMock = NewsServiceMock()
        viewModel = NewsListViewModel(newsService: newsServiceMock)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        newsServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func testViewDidLoadFetchesTopHeadlines() {
        let expectation = XCTestExpectation(description: "Fetch top headlines")

        viewModel.transform(input: Just(.viewDidLoad).eraseToAnyPublisher())
            .sink { output in
                if case .fetchArticlesDidSucceed(let articles) = output {
                    XCTAssertFalse(articles.isEmpty, "Articles should not be empty")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        newsServiceMock.sendSuccessResponse()
        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchFetchesHeadlines() {
        let expectation = XCTestExpectation(description: "Fetch headlines for search query")

        viewModel.transform(input: Just(.search("test")).eraseToAnyPublisher())
            .sink { output in
                if case .fetchArticlesDidSucceed(let articles) = output {
                    XCTAssertFalse(articles.isEmpty, "Articles should not be empty")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        newsServiceMock.sendSuccessResponse()
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadMoreFetchesMoreArticles() {
        let expectation = XCTestExpectation(description: "Fetch more articles")

        viewModel.transform(input: Just(.loadMore).eraseToAnyPublisher())
            .sink { output in
                if case .fetchArticlesDidSucceed(let articles) = output {
                    XCTAssertFalse(articles.isEmpty, "Articles should not be empty")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        newsServiceMock.sendSuccessResponse()
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchArticlesFailure() {
        let expectation = XCTestExpectation(description: "Fetch articles failure")

        viewModel.transform(input: Just(.viewDidLoad).eraseToAnyPublisher())
            .sink { output in
                if case .fetchArticlesDidFail(let error) = output {
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        newsServiceMock.sendFailureResponse()
        wait(for: [expectation], timeout: 1.0)
    }
}

class NewsServiceMock: NewsServiceType {
    private let subject = PassthroughSubject<NewsResponse, Error>()
    
    func getNews(page: Int, query: String) -> AnyPublisher<NewsResponse, Error> {
        return subject.eraseToAnyPublisher()
    }
    
    func sendSuccessResponse() {
        
        let jsonData = """
        {
            "status": "ok",
            "totalResults": 2,
            "articles": [
                {
                    "source": {
                        "id": "cnn",
                        "name": "CNN"
                    },
                    "author": "John Doe",
                    "title": "Sample Article 1",
                    "description": "This is the first sample article.",
                    "url": "https://example.com/article1",
                    "urlToImage": "https://example.com/image1.jpg",
                    "publishedAt": "2024-04-20T14:00:00Z"
                },
                {
                    "source": {
                        "id": "bbc-news",
                        "name": "BBC News"
                    },
                    "author": "Jane Doe",
                    "title": "Sample Article 2",
                    "description": "This is the second sample article.",
                    "url": "https://example.com/article2",
                    "urlToImage": "https://example.com/image2.jpg",
                    "publishedAt": "2024-04-21T15:00:00Z"
                }
            ]
        }
        """.data(using: .utf8)!

        // Decode
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let newsResponse = try! decoder.decode(NewsResponse.self, from: jsonData)
        let response = newsResponse
        
        subject.send(response)
        subject.send(completion: .finished)
    }
    
    func sendFailureResponse() {
        subject.send(completion: .failure(NSError(domain: "test", code: 1, userInfo: nil)))
    }
}

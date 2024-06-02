//
//  NewsDetailViewModelTests.swift
//  NewsTests
//
//  Created by User on 2/6/2567 BE.
//

import XCTest
import Combine
import Core
@testable import News

class NewsDetailViewModelTests: XCTestCase {
    
    private var viewModel: NewsDetailViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        
        let jsonData = """
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
        }
        """.data(using: .utf8)!

        // Decode the JSON data to Article
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let article = try! decoder.decode(Article.self, from: jsonData)
        
        viewModel = NewsDetailViewModel(article: article)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testViewDidLoadDisplaysArticle() {
        let expectation = XCTestExpectation(description: "Display article on viewDidLoad")
        
        viewModel.transform(input: Just(.viewDidLoad).eraseToAnyPublisher())
            .sink { output in
                if case .displayArticle(let imageUrl, let title, let desc, let source, let updateAt) = output {
                    print(updateAt)
                    XCTAssertEqual(imageUrl, "https://example.com/image1.jpg", "Image URL should match")
                    XCTAssertEqual(title, "Sample Article 1", "Title should match")
                    XCTAssertEqual(desc, "This is the first sample article.", "Description should match")
                    XCTAssertEqual(source, "Source: John Doe in CNN", "Source should match")
                    XCTAssertEqual(updateAt, "20 Apr BE 2567", "Published date should match") // Assuming displayDate() formats it this way
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}

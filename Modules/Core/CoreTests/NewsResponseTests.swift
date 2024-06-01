//
//  NewsResponseTests.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import XCTest
@testable import Core

final class NewsResponseTests: XCTestCase {

    func testDecodingNewsResponse() throws {
        // Sample JSON data
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
        let newsResponse = try decoder.decode(NewsResponse.self, from: jsonData)

        // Assert
        XCTAssertEqual(newsResponse.status, "ok")
        XCTAssertEqual(newsResponse.totalResults, 2)
        XCTAssertEqual(newsResponse.articles.count, 2)

        XCTAssertEqual(newsResponse.articles[0].source.id, "cnn")
        XCTAssertEqual(newsResponse.articles[0].source.name, "CNN")
        XCTAssertEqual(newsResponse.articles[0].author, "John Doe")
        XCTAssertEqual(newsResponse.articles[0].title, "Sample Article 1")
        XCTAssertEqual(newsResponse.articles[0].description, "This is the first sample article.")
        XCTAssertEqual(newsResponse.articles[0].url, "https://example.com/article1")
        XCTAssertEqual(newsResponse.articles[0].urlToImage, "https://example.com/image1.jpg")
        XCTAssertEqual(newsResponse.articles[0].publishedAt, "2024-04-20T14:00:00Z")

        XCTAssertEqual(newsResponse.articles[1].source.id, "bbc-news")
        XCTAssertEqual(newsResponse.articles[1].source.name, "BBC News")
        XCTAssertEqual(newsResponse.articles[1].author, "Jane Doe")
        XCTAssertEqual(newsResponse.articles[1].title, "Sample Article 2")
        XCTAssertEqual(newsResponse.articles[1].description, "This is the second sample article.")
        XCTAssertEqual(newsResponse.articles[1].url, "https://example.com/article2")
        XCTAssertEqual(newsResponse.articles[1].urlToImage, "https://example.com/image2.jpg")
        XCTAssertEqual(newsResponse.articles[1].publishedAt, "2024-04-21T15:00:00Z")
    }
}

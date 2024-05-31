//
//  NewsResponse.swift
//  Core
//
//  Created by User on 30/5/2567 BE.
//

import Foundation

public struct NewsResponse: Decodable {
    public let status: String
    public let totalResults: Int
    public let articles: [Article]
}

public struct Article: Decodable {
    public let source: Source
    public let author: String?
    public let title: String
    public let description: String?
    public let url: String
    public let urlToImage: String?
    public let publishedAt: String
}

public struct Source: Decodable {
    public let id: String?
    public let name: String
}

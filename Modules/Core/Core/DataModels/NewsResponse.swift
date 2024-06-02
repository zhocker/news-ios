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

extension Article {
    
    public var displayTitle: String {
        return title
    }
    
    public var displayDescription: String {
        return description ?? ""
    }
    
    public var displayDate: String {
        return publishedAt.displayDate()
    }
    
    public var displayAuthorWithSource: String {
        return "Source: \(author ?? "Unknown") in \(source.name)"
    }
        
}

public struct Source: Decodable {
    public let id: String?
    public let name: String
}

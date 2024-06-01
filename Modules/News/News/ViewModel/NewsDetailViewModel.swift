//
//  NewsDetailViewModel.swift
//  news-ios
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import Combine
import Core

class NewsDetailViewModel {
    
    enum Input {
        case viewDidLoad
    }

    enum Output {
        case displayArticle(imageUrl: String, title: String, desc: String, soruce: String, updateAt: String)
    }

    public let article: Article
    private let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(article: Article) {
        self.article = article
    }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleInput(event)
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func handleInput(_ input: Input) {
        switch input {
        case .viewDidLoad:
            displayArticle()
        }
    }

    private func displayArticle() {
        let displayArticle = Output.displayArticle(imageUrl: self.article.urlToImage ?? "",
                                                   title: self.article.title,
                                                   desc: self.article.description ?? "",
                                                   soruce: "Source: \(article.author ?? "Unknown") in \(article.source.name)",
                                                   updateAt: self.article.publishedAt.displayDate())
        self.output.send(displayArticle)
    }
    
}

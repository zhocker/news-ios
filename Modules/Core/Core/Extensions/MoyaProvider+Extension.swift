//
//  MoyaProvider+Extension.swift
//  news-ios
//
//  Created by User on 31/5/2567 BE.
//

import Foundation
import Combine
import Moya

extension MoyaProvider {
    func requestPublisher<T: Decodable>(_ target: Target, type: T.Type) -> AnyPublisher<T, Error> {
        Future<Response, MoyaError> { promise in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .tryMap { response -> T in
            guard (200...299).contains(response.statusCode) else {
                throw MoyaError.statusCode(response)
            }
            return try JSONDecoder().decode(T.self, from: response.data)
        }
        .eraseToAnyPublisher()
    }
}

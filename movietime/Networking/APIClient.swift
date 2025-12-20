//
//  APIClient.swift
//  movietime
//
//  Created by Sandesh Naik on 15/08/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

enum APIClientError: Error {
    case invalidURL
    case decodingFailed(String)
    case notFound
    case unknown
}


struct APIClient<T: TargetType> {
    
    var moyaProvider: MoyaProvider<T>
    
    init() {
        self.moyaProvider = MoyaProvider<T>()
    }
    
    
    func request<Model: Codable>(_ target: T) -> AnyPublisher<Model, APIClientError> {
        
        return moyaProvider.requestPublisher(target)
            .tryMap { response in
                guard response.statusCode == 200  else {
                    throw APIClientError.notFound
                }
                
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(Model.self, from: response.data)
                    return model
                } catch {
                    throw APIClientError.decodingFailed("Failed to decode data \(error)")
                }
            }
            .mapError { error in
                if let error = error as? APIClientError {
                    return error
                }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}


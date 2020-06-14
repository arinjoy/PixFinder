//
//  NetworkService.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceType {

    private let session: URLSession

    init(with configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never> {
        
        guard let request = resource.request else {
            return .just(.failure(NetworkError.unknown))
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                // 1. Check for network connection related error first
                return self.mapConnectivityError(error)
            }
            .flatMap { data, response -> AnyPublisher<Data, Error> in

                // 2. If reponse came back, check if data exists via `HTTPURLResponse`
                guard let response = response as? HTTPURLResponse else {
                    return .fail(NetworkError.noDataFound)
                }

                // 3. If data exists, then check for negative/faliure HTTP status code
                // and map them to custom errors for potential custom handling
                guard 200..<300 ~= response.statusCode else {
                    return .fail(self.mapHTTPStatusError(statusCode: response.statusCode))
                }
                
                // 4. If everyhting went well return the data response to be
                // decoded as JSON as next step
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map {
                // 5. JSON decoding is successful and return decoded entity/model
                return .success($0)
            }
            .catch { error -> AnyPublisher<Result<T, NetworkError>, Never> in
                // 6. If JSON decoding failts then flag it via failure with custom error wrapper
                return .just(.failure(NetworkError.jsonDecodingError(error: error)))
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Custom Error Mapping Helpers
    
    /// Maps an Error from potential NSError from network connectivity issues
    private func mapConnectivityError(_ error: Error) -> NetworkError {
        let networkError: NSError = error as NSError
        switch networkError.code {
        case NSURLErrorNotConnectedToInternet:
            return .networkFailure
        case NSURLErrorTimedOut:
            return .timeout
        default:
            return .unknown
        }
    }
    
    /// Maps an HTTP negative status code into an custom error enum via `NetworkError`
    private func mapHTTPStatusError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unAuthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 503:
            return .seviceUnavailable
        case 500 ... 599:
            return .server
        default:
            return .unknown
        }
    }
}

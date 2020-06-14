//
//  NetworkServiceType.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 10/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T: Decodable>(_ resource: Resource<T>) -> AnyPublisher<Result<T, NetworkError>, Never>
}

/// Defines the Network service errors.
enum NetworkError: Error {
    
    /// When netowrk cannot be established
    case networkFailure
    
    /// When network call has timed out
    case timeout
    
    // MARK: - Server / Authentication
    
    /// When returns 5xx family of server errors
    case server
    
    /// When service is unaavailable. i.e. 503
    case seviceUnavailable
    
    /// When unauthoized due to bad credentials. i.e. 401
    case unAuthorized
    
    /// When access is forbidden i.e. 403
    case forbidden
    
    /// When api service is not found. i.e. 404
    case notFound
    
    // MARK: - Misc
    
    /// When api does not return data
    case noDataFound
    
//    /// Data loadding
//    case dataLoadingError(statusCode: Int, data: Data)
    
    /// When JSON data mapping/conversion error
    case jsonDecodingError(error: Error)
    
    /// Any unknown error happens
    case unknown
}


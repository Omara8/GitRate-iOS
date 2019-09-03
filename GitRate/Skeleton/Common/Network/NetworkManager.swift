//
//  NetworkManager.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/3/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import enum Result.Result

typealias MappedResult<T> = (Result<T, AppError>) -> Void

class NetworkManager {
    
    var validStatusCodes: CountableClosedRange<Int> {
        return 200...300
    }
    
    var baseUrl: String {
        return "https://gateway.marvel.com:443/v1/public"
    }
    
    var defaultHeaders: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var sharedSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0
        
        let sessionManager: SessionManager = SessionManager(configuration: configuration)
        
        return sessionManager
    }()
    
    static let shared = NetworkManager()
    
    func start<T: Mappable>(request: Request, result: @escaping MappedResult<T>) {
        // This "can" be more generic by including it as part of the request but using JSON in the body is a safe assumption
        let encoding: ParameterEncoding
        if request.method == .post {
            encoding = JSONEncoding.default
        } else {
            encoding = URLEncoding.methodDependent
        }
        
        sharedSessionManager.request(fullUrlString(fromRequest: request),
                                     method: request.method,
                                     parameters: request.parameters,
                                     encoding: encoding,
                                     headers: headers(fromRequest: request))
            .validate(statusCode: validStatusCodes)
            .responseObject { (response: DataResponse<T>) in
                
                
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        result(.success(value))
                    }
                case let .failure(error):
                    let hubError = AppError(fromError: error)
                    result(.failure(hubError))
                    
                }
        }
    }
    
    // MARK: - Private functions
    
    /// Combines default headers with request headers.
    /// Prefers request headers in case of key duplication.
    private func headers(fromRequest request: Request) -> [String: String] {
        guard let requestHeaders = request.headers else {
            return defaultHeaders
        }
        
        return requestHeaders.merging(defaultHeaders, uniquingKeysWith: { (requestHeaders, _) in requestHeaders })
    }
    
    /// Builds full path of the request using the base URL and path property of the request.
    /// Prefers the request base URL over the client's in case it's provided.
    private func fullUrlString(fromRequest request: Request) -> URLConvertible {
        if let baseUrl = request.baseUrl {
            return baseUrl + request.path
        }else{
            guard !self.baseUrl.isEmpty else {
                fatalError("Generic API client cannot be used without a base URL. Please provide a base URL or use one of the dedicated clients with a predefined base URL.")
            }
            return baseUrl + request.path
        }
    }
}

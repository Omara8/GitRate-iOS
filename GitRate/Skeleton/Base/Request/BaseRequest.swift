//
//  BaseRequest.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/3/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Alamofire

protocol Request {
    
    // The request base URL.
    // It's optional and can be moved to a Request extension. Usually defined by the `Client`.
    var baseUrl: String? { get }
    
    // The request path.
    var path: String { get }
    
    // The request method.
    var method: HTTPMethod { get }
    
    // The request headers.
    // It's optional and can be moved to a Request extension. Usually defined by the `Client`.
    var headers: [String: String]? { get }
    
    // The request parameters.
    var parameters: [String: Any]? { get }
    
    // The request cache policy.
    var cachePolicy: URLRequest.CachePolicy? { get }
}

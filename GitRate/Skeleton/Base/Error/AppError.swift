//
//  AppError.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/3/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Foundation
import Alamofire

enum AppError: Error {
    
    case unknown
    case authorization
    case noConnection
    case timeout
    
    init(fromError error: Error?) {
        guard error != nil else {
            self = .unknown
            return
        }
        
        if let error = error as? AFError {
            switch error {
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    switch code {
                    case 401:
                        self = .authorization
                    default:
                        self = .unknown
                    }
                default:
                    self = .unknown
                }
            default:
                self = .unknown
            }
        } else if let error = error as NSError? {
            switch error.code {
            case NSURLErrorNotConnectedToInternet:
                self = .noConnection
            case NSURLErrorTimedOut:
                self = .timeout
            case NSURLErrorUserAuthenticationRequired:
                self = .authorization
            default:
                self = .unknown
            }
        } else {
            self = .unknown
        }
    }
}

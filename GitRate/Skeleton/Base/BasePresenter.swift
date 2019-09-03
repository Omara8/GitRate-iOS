//
//  BasePresenter.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/3/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Foundation

typealias BaseViewType<T> = T where T: View

class BasePresenter: Presenter {
    
    let validateSessionUseCase: ValidateSessionUseCase! = ValidateSessionUseCase()
    
    weak var baseView: View!
    
    init(baseView: View) {
        self.baseView = baseView
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func retry(dissmisable: Bool) {
        if dissmisable {
            baseView?.hideStateView()
        }
        start()
    }
    
    func validateSession(message: String) {
        self.baseView.disableStateViewInteraction()
//        validateSessionUseCase.execute { [weak self] (result) in
//            switch result {
//            case .success:
//                self?.retry(dissmisable: true)
//            case .failure:
//                // HAX: ADAL works in the background
//                if let self = self {
//                    self.baseView.showErrorView(withMessage: message, source: self, dissmisable: false)
//                    self.baseView.enableStateViewInteraction()
//                }
//            }
//        }
    }
    
    func handle(error: AppError) {
        let message: String = localizedMessage(forError: error)
        
        switch (error, baseView.state) {
        case (.unknown, .populated),
             (.noConnection, .populated),
             (.timeout, .populated):
            baseView.showToast(withMessage: message, status: .failure)
        case (.unknown, _),
             (.noConnection, _),
             (.timeout, _):
            baseView.showErrorView(withMessage: message, source: self, dissmisable: true)
        case (.authorization, _):
            validateSession(message: message)
            
        }
    }
    
    func localizedMessage(forError error: AppError) -> String {
        switch error {
        case .unknown:
            return "There has been a technical error."
        case .authorization:
            return "Session expired."
        case .noConnection:
            return "Please check your connection."
        case .timeout:
            return "This took longer than usual."
        }
    }
}

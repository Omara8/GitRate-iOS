//
//  View.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/3/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Foundation

enum ViewState {
    case none
    case populated
    case error
}

public enum ToastStatus {
    case success
    case normal
    case failure
}

protocol View: class {
    
    var state: ViewState { get set }
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showLoadingDialog()
    func showLoadingDialog(withMessage message: String)
    func hideLoadingDialog(completion: (()->())?)
    func showErrorView(withMessage message: String, source: BasePresenter, dissmisable: Bool)
    func hideStateView()
    func showToast(withMessage message: String, status: ToastStatus)
    func navigate(to route: Route)
    func present(route: Route)
    func replace(with route: Route)
    func setWindowRoot(to route: Route)
    func openInBrowser(url: URL)
    func enableStateViewInteraction()
    func disableStateViewInteraction()
}

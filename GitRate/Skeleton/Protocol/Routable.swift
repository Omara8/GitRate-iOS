//
//  Routable.swift
//  GitRate
//
//  Created by Mahmoud Omara on 9/16/19.
//  Copyright © 2019 PlanATech. All rights reserved.
//

import Foundation

import UIKit
import SafariServices

protocol Routable {
    static func routeTo(scheme: String, id: String?)
    func destination() -> UIViewController
}

extension UIViewController {
    
    func navigate(to route: Route) {
        navigationController?.pushViewController(route.destination(), animated: true)
    }
    
    func present(route: Route) {
        present(route.destination(), animated: true, completion: nil)
    }
    
    func replace(with route: Route) {
        navigationController?.viewControllers = [route.destination()]
    }
    
    func setWindowRoot(to route: Route) {
        guard UIApplication.shared.windows.isEmpty == false else {
            return
        }
        
        let window = UIApplication.shared.windows.first
        let navigationController = UINavigationController(rootViewController: route.destination())
        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
    }
}


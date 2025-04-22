//
//  BaseCoordinator.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("should implement this first")
    }
    
    func pushViewController<T: UIViewController>(_ viewController: T, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func presentViewController<T: UIViewController>(_ viewController: T, animated: Bool = true) {
        navigationController.present(viewController, animated: animated, completion: nil)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
}

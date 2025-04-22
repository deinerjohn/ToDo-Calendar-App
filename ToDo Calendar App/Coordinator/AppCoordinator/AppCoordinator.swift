//
//  AppCoordinator.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import ReSwift
import domain


final class AppCoordinator: BaseCoordinator {
    private var tabBarController: MainTabViewController
    private let userUseCase: UserUseCaseProtocol
    private let toDoUseCase: ToDoUseCaseProtocol
    
    init(navigationController: UINavigationController, userUseCase: UserUseCaseProtocol, toDoUseCase: ToDoUseCaseProtocol) {
        
        self.toDoUseCase = toDoUseCase
        self.userUseCase = userUseCase
        self.tabBarController = MainTabViewController(toDoUseCase: toDoUseCase, userUseCase: userUseCase)
        
        super.init(navigationController: navigationController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func start() {
        navigationController.setViewControllers([tabBarController], animated: false)
        showInitialState()
        showLoginIfNeeded()
        observeLogout()
    }
    
    private func observeLogout() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .didRequestLogout, object: nil)
    }
    
    private func showInitialState() {
        guard let userId = userUseCase.fetchLoggedInUserId() else { return }
        
        StoreProvider.shared.dispatch(ToDoAction.setUser(userId))
        StoreProvider.shared.dispatch(ToDoAction.loadToDoItems(userId))
    }

    private func showLoginIfNeeded() {
        guard userUseCase.fetchLoggedInUserId() == nil else { return }

        let loginVM = LoginViewModel(userUseCase: userUseCase)
        let loginVC = LoginViewController(viewModel: loginVM)
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        loginVC.delegate = self
        
        DispatchQueue.main.async { [weak self] in
            self?.presentViewController(navController, animated: false)
        }
    }
    
    @objc private func handleLogout() {
        showLoginIfNeeded()
    }
    
}

extension AppCoordinator: LoginViewController.Delegate {
    
    func showRegisterScreen(from: LoginViewController) {
        
        let registerViewController = RegisterViewController(viewModel: RegisterViewModel(userUseCase: self.userUseCase))
        registerViewController.isModalInPresentation = true
        DispatchQueue.main.async { [weak self] in
            from.present(registerViewController, animated: true)
        }
    }
    
    func onLoginSuccess(userId: String) {
        self.userUseCase.setLoggedInUser(userId: userId)
        StoreProvider.shared.dispatch(ToDoAction.setUser(userId))
        
        StoreProvider.shared.dispatch(ToDoAction.loadToDoItems(userId))
        dismiss()
    }
}

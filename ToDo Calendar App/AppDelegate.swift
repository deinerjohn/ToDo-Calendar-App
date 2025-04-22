//
//  AppDelegate.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import domain
import data
import infrastructure

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let userlocalDataSourceImpl: UserLocalDataSource = UserLocalDataSourceImpl()
        let userRepo = UserRepository(userLocalDataSource: userlocalDataSourceImpl)
        let userUseCase = UserUseCase(userRepository: userRepo)
        
        let todolocalDataSourceImpl: ToDoLocalDataSource = ToDoLocalDataSourceImpl()
        let todoRepo = ToDoRepository(toDoLocalDataSource: todolocalDataSourceImpl)
        let todoUseCase = ToDoUseCase(toDoRepository: todoRepo, toDoJSONHelper: ToDoJSONHelper.shared)
        
        let navController = UINavigationController()
        
        appCoordinator = AppCoordinator(navigationController: navController, userUseCase: userUseCase, toDoUseCase: todoUseCase)
        
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
        
    }

}


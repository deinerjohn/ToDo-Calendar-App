//
//  MainTabViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import domain

class MainTabViewController: UITabBarController {
    
    private let toDoUseCase: ToDoUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    
    init(toDoUseCase: ToDoUseCaseProtocol, userUseCase: UserUseCaseProtocol) {
        self.toDoUseCase = toDoUseCase
        self.userUseCase = userUseCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabs()
    }
    
    private func setupTabs() {
        
        let todoVC = ToDoListViewController(viewModel: ToDoListViewModel(userUseCase: userUseCase))
        todoVC.title = "To-Do"
        let todoNav = UINavigationController(rootViewController: todoVC)
        todoNav.tabBarItem = UITabBarItem(title: "To-Do", image: UIImage(systemName: "checkmark.circle"), tag: 0)

        let calendarVC = CalendarViewController(viewModel: CalendarViewModel(toDoUseCase: toDoUseCase, userUseCase: userUseCase))
        calendarVC.title = "Calendar"
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        calendarNav.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 1)
        
        self.viewControllers = [
            todoNav,
            calendarNav
        ]
        
    }
}


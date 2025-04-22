//
//  StoreProvider.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import ReSwift
import domain
import data
import infrastructure

final class StoreProvider {
    
    static let shared: Store<AppState> = {
        let toDoLocalDataSource: ToDoLocalDataSource = ToDoLocalDataSourceImpl()
        let toDoRepository = ToDoRepository(toDoLocalDataSource: toDoLocalDataSource)
        let toDoUseCase = ToDoUseCase(toDoRepository: toDoRepository, toDoJSONHelper: ToDoJSONHelper.shared)
        return Store<AppState>(
            reducer: appReducer,
            state: nil,
            middleware: [toDoMiddleware(toDoUseCase: toDoUseCase)]
        )
    }()
    
}

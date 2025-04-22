//
//  AppReducer.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import ReSwift
import domain

func toDoMiddleware(toDoUseCase: ToDoUseCaseProtocol) -> Middleware<AppState> {
    return { dispatch, getState in
        return { next in
            return { action in
                // Forward the action first
                next(action)

                switch action {
                case let ToDoAction.loadToDoItems(userId):
                    let items = toDoUseCase.fetchToDoItems(for: userId)
                    dispatch(ToDoAction.setItems(items))

                case let ToDoAction.addItem(item):
                    toDoUseCase.saveToDoItem(item)

                case let ToDoAction.updateItem(item):
                    toDoUseCase.updateToDoItem(item)

                case let ToDoAction.deleteItem(todoId):
                    toDoUseCase.deleteToDoItem(todoId)
                    

                default:
                    break
                }
            }
        }
    }
}


func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let ToDoAction.setUser(userId):
        state.currentUserId = userId
        
    case let ToDoAction.setItems(items):
        state.toDoItems = items

    case let ToDoAction.addItem(item):
        state.toDoItems.append(item)

    case let ToDoAction.updateItem(item):
        if let index = state.toDoItems.firstIndex(where: { $0.id == item.id }) {
            state.toDoItems[index] = item
        }

    case let ToDoAction.deleteItem(item):
        state.toDoItems.removeAll { $0.id == item.id }

    default:
        break
    }

    return state
}

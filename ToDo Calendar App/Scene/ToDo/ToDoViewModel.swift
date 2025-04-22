//
//  ToDoViewModel.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import ReSwift
import domain

final class ToDoListViewModel {
    
    private let userUseCase: UserUseCaseProtocol
    private let store: Store<AppState>

    init(userUseCase: UserUseCaseProtocol, store: Store<AppState> = StoreProvider.shared) {
        self.userUseCase = userUseCase
        self.store = store
    }

    var sortedItems: [ToDoItem] {
        store.state.toDoItems.sorted { (first: ToDoItem, second: ToDoItem) in
            let statusOrder: [ToDoStatus] = [.inProgress, .notStarted, .done]
            let firstStatusIndex = statusOrder.firstIndex(of: first.setTodoStatus) ?? statusOrder.count
            let secondStatusIndex = statusOrder.firstIndex(of: second.setTodoStatus) ?? statusOrder.count

            if firstStatusIndex == secondStatusIndex {
                return first.startDate < second.startDate
            } else {
                return firstStatusIndex < secondStatusIndex
            }
        }
    }
    
    var currentUserId: String {
        userUseCase.fetchLoggedInUserId() ?? ""
    }

    func loadItems() {
        guard let userId = userUseCase.fetchLoggedInUserId() else { return }
        StoreProvider.shared.dispatch(ToDoAction.loadToDoItems(userId))
    }

    func addItem(title: String, description: String, start: String, end: String, priority: ToDoPriority) {
        guard let userId = userUseCase.fetchLoggedInUserId() else { return }

        let newItem = ToDoItem(
            id: UUID().uuidString,
            title: title,
            description: description,
            startDate: start,
            endDate: end,
            userId: userId,
            priority: priority
        )

        StoreProvider.shared.dispatch(ToDoAction.addItem(newItem))
        loadItems()
    }
    
    func updateItem(id: String, title: String, description: String, start: String, end: String, priority: ToDoPriority) {
        guard let userId = userUseCase.fetchLoggedInUserId() else { return }

        let updatedItem = ToDoItem(
            id: id,
            title: title,
            description: description,
            startDate: start,
            endDate: end,
            userId: userId,
            priority: priority
        )

        StoreProvider.shared.dispatch(ToDoAction.updateItem(updatedItem))
        loadItems()
    }
    
    func deleteItem(_ item: ToDoItem) {
        StoreProvider.shared.dispatch(ToDoAction.deleteItem(item))
        loadItems()
    }
    
    func logout() {
        userUseCase.setLoggedInUser(userId: nil)
        StoreProvider.shared.dispatch(ToDoAction.setUser(nil))
    }
}

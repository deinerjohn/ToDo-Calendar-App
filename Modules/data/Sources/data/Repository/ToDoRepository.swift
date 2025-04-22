//
//  ToDoRepository.swift
//  data
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import domain

public class ToDoRepository: ToDoRepositoryProtocol {
    private let toDoLocalDataSource: ToDoLocalDataSource

    public init(toDoLocalDataSource: ToDoLocalDataSource) {
        self.toDoLocalDataSource = toDoLocalDataSource
    }

    public func saveItem(_ toDoItem: ToDoItem) {
        toDoLocalDataSource.saveItem(toDoItem)
    }

    public func fetchItems(for userId: String) -> [ToDoItem] {
        return toDoLocalDataSource.fetchItems(for: userId)
    }

    public func deleteItem(_ toDoItem: ToDoItem) {
        toDoLocalDataSource.deleteItem(toDoItem)
    }

    public func updateItem(_ toDoItem: ToDoItem) {
        toDoLocalDataSource.updateItem(toDoItem)
    }

    public func deleteAllToDos() {
        toDoLocalDataSource.deleteAllToDos()
    }
}

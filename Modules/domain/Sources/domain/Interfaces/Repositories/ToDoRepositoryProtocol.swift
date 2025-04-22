//
//  ToDoRepositoryProtocol.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

public protocol ToDoRepositoryProtocol {
    func saveItem(_ toDoItem: ToDoItem)
    func fetchItems(for userId: String) -> [ToDoItem]
    func deleteItem(_ toDoItem: ToDoItem)
    func updateItem(_ toDoItem: ToDoItem)
    func deleteAllToDos()
}

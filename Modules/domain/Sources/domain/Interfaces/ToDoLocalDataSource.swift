//
//  ToDoLocalDataSource.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation

public protocol ToDoLocalDataSource {
    func saveItem(_ toDoItem: ToDoItem)
    
    func fetchItems(for userId: String) -> [ToDoItem]
    
    func deleteItem(_ toDoItem: ToDoItem)
    
    func updateItem(_ toDoItem: ToDoItem)
    
    func deleteAllToDos()
    
}

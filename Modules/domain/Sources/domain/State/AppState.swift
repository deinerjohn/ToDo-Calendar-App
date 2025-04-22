//
//  AppState.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

public struct AppState {
    public var currentUserId: String?
    public var toDoItems: [ToDoItem] = []

    public init(currentUserId: String? = nil, toDoItems: [ToDoItem] = []) {
        self.currentUserId = currentUserId
        self.toDoItems = toDoItems
    }
}

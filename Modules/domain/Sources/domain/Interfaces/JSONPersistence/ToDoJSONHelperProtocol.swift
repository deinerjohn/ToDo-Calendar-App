//
//  ToDoJSONHelperProtocol.swift
//  domain
//
//  Created by Deiner John Calbang on 4/22/25.
//

public protocol ToDoJSONHelperProtocol {
    
    func saveToDoItems(_ items: [ToDoItem], for userId: String)
    
    func loadToDoItems(for userId: String) -> [ToDoItem]?
    
}

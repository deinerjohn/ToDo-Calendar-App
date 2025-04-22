//
//  ToDoAction.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import ReSwift
import domain

enum ToDoAction: Action {
    
    case setUser(String?)
    
    case setItems([ToDoItem])
    
    case addItem(ToDoItem)
    
    case updateItem(ToDoItem)
    
    case deleteItem(ToDoItem)
    
    case loadToDoItems(String)
    
}


//
//  ToDoLocalDataSourceImpl.swift
//  infrastructure
//
//  Created by Deiner John Calbang on 4/21/25.
//

import SQLite
import domain

public class ToDoLocalDataSourceImpl: ToDoLocalDataSource {
    
    private let helper = SQLiteHelper()
    
    public init() {}
    
    public func saveItem(_ toDoItem: domain.ToDoItem) {
        let itemsTable = helper.items
        let insert = itemsTable.insert(
            helper.itemId <- toDoItem.id,
            helper.itemTitle <- toDoItem.title,
            helper.itemDescription <- toDoItem.description,
            helper.itemStartDate <- toDoItem.startDate,
            helper.itemEndDate <- toDoItem.endDate,
            helper.itemUserId <- toDoItem.userId,
            helper.itemPriority <- toDoItem.priority.rawValue
        )
        
        do {
            try helper.db?.run(insert)
            print("Successfully saved ToDoItem")
        } catch {
            print("Failed to save ToDoItem: \(error)")
        }
    }
    
    public func fetchItems(for userId: String) -> [domain.ToDoItem] {
        let itemsTable = helper.items
        let query = itemsTable.filter(helper.itemUserId == userId)
        
        var toDoItems: [domain.ToDoItem] = []
        
        do {
            let resultSet = try helper.db?.prepare(query) ?? AnySequence([])
            
            for item in resultSet {
                let startDateString = item[helper.itemStartDate]
                let endDateString = item[helper.itemEndDate]
                
                let toDoItem = domain.ToDoItem(
                    id: item[helper.itemId],
                    title: item[helper.itemTitle],
                    description: item[helper.itemDescription],
                    startDate: startDateString,
                    endDate: endDateString,
                    userId: item[helper.itemUserId],
                    priority: ToDoPriority(rawValue: item[helper.itemPriority]) ?? .low
                )
                toDoItems.append(toDoItem)
            }
        } catch {
            print("Failed to fetch ToDoItems: \(error)")
        }
        
        return toDoItems
    }
    
    public func deleteItem(_ toDoItem: domain.ToDoItem) {
        let itemsTable = helper.items
        let query = itemsTable.filter(helper.itemId == toDoItem.id)
        
        do {
            try helper.db?.run(query.delete())
            print("Successfully deleted ToDoItem with ID: \(toDoItem.id)")
        } catch {
            print("Failed to delete ToDoItem: \(error)")
        }
    }
    
    public func updateItem(_ toDoItem: domain.ToDoItem) {
        let itemsTable = helper.items
        let query = itemsTable.filter(helper.itemId == toDoItem.id)
        
        let update = query.update(
            helper.itemTitle <- toDoItem.title,
            helper.itemDescription <- toDoItem.description,
            helper.itemStartDate <- toDoItem.startDate,
            helper.itemEndDate <- toDoItem.endDate,
            helper.itemPriority <- toDoItem.priority.rawValue
        )
        
        do {
            try helper.db?.run(update)
            print("Successfully updated ToDoItem with ID: \(toDoItem.id)")
        } catch {
            print("Failed to update ToDoItem: \(error)")
        }
    }
    
    public func deleteAllToDos() {
        let itemsTable = helper.items
        
        do {
            try helper.db?.run(itemsTable.delete())
            print("Successfully deleted all ToDoItems")
        } catch {
            print("Failed to delete all ToDoItems: \(error)")
        }
    }
    
}

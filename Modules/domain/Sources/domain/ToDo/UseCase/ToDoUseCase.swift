//
//  ToDoUseCase.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

public protocol ToDoUseCaseProtocol {
    func saveToDoItem(_ toDoItem: ToDoItem)
    func fetchToDoItems(for userId: String) -> [ToDoItem]
    func deleteToDoItem(_ toDoItem: ToDoItem)
    func updateToDoItem(_ toDoItem: ToDoItem)
}

public class ToDoUseCase: ToDoUseCaseProtocol {
    private let toDoRepository: ToDoRepositoryProtocol
    private let toDoPersistence: ToDoJSONHelperProtocol

    public init(toDoRepository: ToDoRepositoryProtocol, toDoJSONHelper: ToDoJSONHelperProtocol) {
        self.toDoRepository = toDoRepository
        self.toDoPersistence = toDoJSONHelper
    }

    public func saveToDoItem(_ toDoItem: ToDoItem) {
        toDoRepository.saveItem(toDoItem)
        var allItems = toDoPersistence.loadToDoItems(for: toDoItem.userId) ?? []
        allItems.append(toDoItem)
        toDoPersistence.saveToDoItems(allItems, for: toDoItem.userId)
    }

    public func fetchToDoItems(for userId: String) -> [ToDoItem] {
        return toDoRepository.fetchItems(for: userId)
    }

    public func deleteToDoItem(_ toDoItem: ToDoItem) {
        toDoRepository.deleteItem(toDoItem)
        
        let allItems = toDoRepository.fetchItems(for: toDoItem.userId)
        
        let updatedItems = allItems.filter { $0.id == toDoItem.id }
        toDoPersistence.saveToDoItems(updatedItems, for: toDoItem.userId)
        
    }

    public func updateToDoItem(_ toDoItem: ToDoItem) {
        toDoRepository.updateItem(toDoItem)
        
        var items = toDoPersistence.loadToDoItems(for: toDoItem.userId) ?? []
        if let index = items.firstIndex(where: { $0.id == toDoItem.id }) {
            items[index] = toDoItem
            toDoPersistence.saveToDoItems(items, for: toDoItem.userId)
        }
    }
    
}


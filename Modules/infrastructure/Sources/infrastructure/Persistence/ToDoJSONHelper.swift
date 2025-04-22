//
//  ToDoJSONHelper.swift
//  infrastructure
//
//  Created by Deiner John Calbang on 4/22/25.
//

import Foundation
import domain

public final class ToDoJSONHelper: ToDoJSONHelperProtocol {

    public static let shared = ToDoJSONHelper()
    
    private init() {}

    private func fileURL(for userId: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(userId)_todo_items.json")
    }
    
    public func saveToDoItems(_ items: [ToDoItem], for userId: String) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(items)
            let fileURL = self.fileURL(for: userId)
            try data.write(to: fileURL)
            print("ToDo items saved successfully to \(fileURL.path)")
        } catch {
            print("Failed to save ToDo items to JSON for user \(userId): \(error)")
        }
    }

    public func loadToDoItems(for userId: String) -> [ToDoItem]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Make sure the date is decoded correctly
        let fileURL = self.fileURL(for: userId)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let items = try decoder.decode([ToDoItem].self, from: data)
            return items
        } catch {
            print("Failed to load ToDo items from JSON for user \(userId): \(error)")
            return nil
        }
    }
    
}

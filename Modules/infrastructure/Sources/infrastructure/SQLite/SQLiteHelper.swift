//
//  SQLiteHelper.swift
//  infrastructure
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import SQLite


public class SQLiteHelper {
    public var db: Connection?
    
    // Table references
    public let users = Table("users")
    public let items = Table("items")

    // Columns (User)
    public let userId: SQLite.Expression<String> = Expression<String>("id")
    public let name: SQLite.Expression<String> = Expression<String>("name")
    public let passwordHash: SQLite.Expression<String> = Expression<String>("passwordHash")

    // Columns (Item)
    public let itemId: SQLite.Expression<String> = Expression<String>("id")
    public let itemTitle: SQLite.Expression<String> = Expression<String>("title")
    public let itemDescription: SQLite.Expression<String> = Expression<String>("description")
    public let itemStartDate: SQLite.Expression<String> = Expression<String>("startDate")
    public let itemEndDate: SQLite.Expression<String> = Expression<String>("endDate")
    public let itemUserId: SQLite.Expression<String> = Expression<String>("userId")
    public let itemPriority: SQLite.Expression<String> = Expression<Int>("priority")
    
    private let fileName = "todo_calendar.sqlite3"

    public init() {
        self.initDB()
    }
    
    private func initDB() {
        do {
            let dbPath = dbPath()
            print("This is your db file path: \(dbPath)")
            db = try Connection(dbPath)
            createTables()
        } catch {
            
        }
    }
    
    private func dbPath() -> String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName).path
    }
    
    private func createTables() {
        createUserTable()
        createItemTable()       // Unified table for items (ToDo/Calendar)
    }

    // Create User Table
    private func createUserTable() {
        do {
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: true)
                t.column(name)
                t.column(passwordHash)             // To store password hash
            })
        } catch {
            print("Failed to create users table: \(error)")
        }
    }

    // Create Unified Item Table (ToDo and Calendar)
    private func createItemTable() {
        do {
            try db?.run(items.create(ifNotExists: true) { t in
                t.column(itemId, primaryKey: true)
                t.column(itemTitle)
                t.column(itemDescription)
                t.column(itemStartDate)
                t.column(itemEndDate)
                t.column(itemUserId)
                t.column(itemPriority)
            })
        } catch {
            print("Failed to create items table: \(error)")
        }
    }
    
}

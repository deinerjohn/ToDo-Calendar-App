//
//  UserLocalDataSourceImpl.swift
//  infrastructure
//
//  Created by Deiner John Calbang on 4/21/25.
//

import SQLite
import domain
import Foundation

public class UserLocalDataSourceImpl: UserLocalDataSource {
    
    private let helper = SQLiteHelper()
    private let loggedInUserKey = "loggedInUserId"
    
    public init() {}
    
    public func saveUserCredentials(userId: String, name: String, passwordHash: String) -> Bool {
        let userTable = helper.users
        let insert = userTable.insert(
            helper.userId <- userId,
            helper.name <- name,
            helper.passwordHash <- passwordHash
        )
        
        do {
            try helper.db?.run(insert)
            return true
        } catch {
            print("Failed to insert user credentials: \(error)")
            return false
        }
    }
    
    public func getUserCredentials(by userId: String) -> (name: String, passwordHash: String)? {
        let userTable = helper.users
        let query = userTable.filter(helper.userId == userId)
        
        do {
            if let user = try helper.db?.pluck(query) {
                let name = user[helper.name]
                let passwordHash = user[helper.passwordHash]
                return (name, passwordHash)
            }
        } catch {
            print("Failed to retrieve user credentials: \(error)")
        }
        
        return nil
    }
    
    public func userExists(by userId: String) -> Bool {
        let userTable = helper.users
        let query = userTable.filter(helper.userId == userId)
        
        do {
            if let _ = try helper.db?.pluck(query) {
                return true
            }
        } catch {
            print("Failed to check if user exists: \(error)")
        }
        
        return false
    }
    
    public func checkUserLogin(userId: String, passwordHash: String) -> Bool {
        let userTable = helper.users
        let query = userTable.filter(helper.userId == userId)
        
        do {
            if let user = try helper.db?.pluck(query) {
                let storedPasswordHash = user[helper.passwordHash]
                return storedPasswordHash == passwordHash
            }
        } catch {
            print("Failed to check user login credentials: \(error)")
        }
        
        return false
    }
    
    
    public func fetchLoggedInUserId() -> String? {
        return UserDefaults.standard.string(forKey: loggedInUserKey)
    }
    
    public func setLoggedInUser(userId: String?) {
        UserDefaults.standard.set(userId, forKey: loggedInUserKey)
    }
    
    
}

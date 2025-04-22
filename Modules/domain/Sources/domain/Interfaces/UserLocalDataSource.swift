//
//  UserLocalDataSource.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation

public protocol UserLocalDataSource {
    
    func saveUserCredentials(userId: String, name: String, passwordHash: String) -> Bool

    func getUserCredentials(by userId: String) -> (name: String, passwordHash: String)?

    func userExists(by userId: String) -> Bool
    
    func checkUserLogin(userId: String, passwordHash: String) -> Bool
    
    func fetchLoggedInUserId() -> String?
    
    func setLoggedInUser(userId: String?)
}

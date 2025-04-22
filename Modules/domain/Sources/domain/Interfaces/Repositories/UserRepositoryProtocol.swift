//
//  UserRepositoryProtocol.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation

public protocol UserRepositoryProtocol {
    func saveUser(userId: String, name: String, passwordHash: String) -> Bool
    
    func getUser(by userId: String) -> (name: String, passwordHash: String)?
    
    func checkIfUserExists(by userId: String) -> Bool
    
    func checkUserLogin(userId: String, passwordHash: String) -> Bool
    
    func fetchLoggedInUserId() -> String?
    
    func setLoggedInUser(userId: String?)
}

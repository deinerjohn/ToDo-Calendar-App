//
//  UserRepository.swift
//  data
//
//  Created by Deiner John Calbang on 4/21/25.
//

import domain

public class UserRepository: UserRepositoryProtocol {
    private let userLocalDataSource: UserLocalDataSource

    public init(userLocalDataSource: UserLocalDataSource) {
        self.userLocalDataSource = userLocalDataSource
    }
    
    public func saveUser(userId: String, name: String, passwordHash: String) -> Bool {
        return userLocalDataSource.saveUserCredentials(userId: userId, name: name, passwordHash: passwordHash)
    }
    
    public func getUser(by userId: String) -> (name: String, passwordHash: String)? {
        return userLocalDataSource.getUserCredentials(by: userId)
    }
    
    public func checkIfUserExists(by userId: String) -> Bool {
        return userLocalDataSource.userExists(by: userId)
    }
    
    public func checkUserLogin(userId: String, passwordHash: String) -> Bool {
        return userLocalDataSource.checkUserLogin(userId: userId, passwordHash: passwordHash)
    }
    
    public func fetchLoggedInUserId() -> String? {
        return userLocalDataSource.fetchLoggedInUserId()
    }
    
    public func setLoggedInUser(userId: String?) {
        return userLocalDataSource.setLoggedInUser(userId: userId)
    }
    

}

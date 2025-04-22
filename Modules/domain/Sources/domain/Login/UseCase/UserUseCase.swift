//
//  UserUseCase.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

public protocol UserUseCaseProtocol {
    
    func saveUser(userId: String, name: String, passwordHash: String) -> Bool
    
    func getUser(by userId: String) -> (name: String, passwordHash: String)?
    
    func checkIfUserExists(by userId: String) -> Bool
    
    func checkUserLogin(userId: String, passwordHash: String) -> Bool
    
    func fetchLoggedInUserId() -> String?
    
    func setLoggedInUser(userId: String?)
    
}

public class UserUseCase: UserUseCaseProtocol {
    
    private let userRepository: UserRepositoryProtocol

    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    public func saveUser(userId: String, name: String, passwordHash: String) -> Bool {
        return userRepository.saveUser(userId: userId, name: name, passwordHash: passwordHash)
    }

    public func getUser(by userId: String) -> (name: String, passwordHash: String)? {
        return userRepository.getUser(by: userId)
    }

    public func checkIfUserExists(by userId: String) -> Bool {
        return userRepository.checkIfUserExists(by: userId)
    }

    public func checkUserLogin(userId: String, passwordHash: String) -> Bool {
        return userRepository.checkUserLogin(userId: userId, passwordHash: passwordHash)
    }
    
    public func fetchLoggedInUserId() -> String? {
        return userRepository.fetchLoggedInUserId()
    }
    
    public func setLoggedInUser(userId: String?) {
        return userRepository.setLoggedInUser(userId: userId)
    }
}

//
//  RegisterViewModel.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import domain

class RegisterViewModel {

    enum Input {
        case userIdChanged(String)
        case passwordChanged(String)
        case nameChanged(String)
        case confirmPasswordChanged(String)
        case registerTapped
    }

    enum Output {
        case passwordValidationError(String)
        case validationError(String)
        case registerSuccess
        case registerFailure(String)
        case isRegisterEnabled(Bool)
        case hidePasswordErrorMessage
        case passwordStrengthErrorMessage(String)
        case nameValidationError(String)
        case hideNameErrorMessage
    }

    private let userUseCase: UserUseCaseProtocol
    private var userId: String = ""
    private var fullName: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""

    var output = PublishSubject<Output>()
    private let disposeBag = DisposeBag()

    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
    }

    func transform(input: Input) {
        switch input {
        case .userIdChanged(let userId):
            self.userId = userId
            validateRegisterButtonState()
            
        case .nameChanged(let name):
            self.fullName = name
            validateRegisterButtonState()

        case .passwordChanged(let password):
            self.password = password
            validateRegisterButtonState()

        case .confirmPasswordChanged(let confirmPassword):
            self.confirmPassword = confirmPassword
            validateRegisterButtonState()

        case .registerTapped:
            register()
            
        }
    }

    private func validateRegisterButtonState() {
        let isValid = !userId.isEmpty && !fullName.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword && fullName.isValidName
        
        if fullName.count > 0 && !fullName.isValidName {
            output.onNext(.nameValidationError("Name must contain only letters"))
        } else {
            output.onNext(.hideNameErrorMessage)
        }
        
        if (!confirmPassword.isEmpty && !password.isEmpty) &&
            (password != confirmPassword)
        {
            output.onNext(.passwordValidationError("Passwords do not match"))
        } else {
            output.onNext(.hidePasswordErrorMessage)
        }
        
        output.onNext(.isRegisterEnabled(isValid))
    }

    private func register() {
        guard !userId.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            output.onNext(.validationError("All fields are required"))
            return
        }
        
        guard password.isPasswordStrong else {
            output.onNext(.passwordStrengthErrorMessage("Password must be at least 6 characters, include 1 capital letter and 1 number"))
            return
        }
        
        if userUseCase.checkIfUserExists(by: userId) {
            output.onNext(.registerFailure("User already exists"))
            return
        }

        let passwordHash = password // You can hash the password before storing it
        let savedSuccessfully = userUseCase.saveUser(userId: userId, name: fullName, passwordHash: passwordHash)

        if savedSuccessfully {
            output.onNext(.registerSuccess)
        } else {
            output.onNext(.registerFailure("Failed to register user"))
        }
    }
    
    
}

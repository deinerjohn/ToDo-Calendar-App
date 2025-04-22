//
//  LoginViewModel.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import domain
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    enum Input {
        case userIdChanged(String)
        case passwordChanged(String)
        case loginTapped
    }

    enum Output {
        case validationError(String)
        case loginSuccess(String)
        case loginFailure(String)
        case isLoginEnabled(Bool)
    }
    
    
    var output = PublishSubject<Output>()
    private let disposeBag = DisposeBag()
    
    let userUseCase: UserUseCaseProtocol

    private var userId: String = ""
    private var password: String = ""

    init(userUseCase: UserUseCaseProtocol) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: Input) {
        switch input {
        case .userIdChanged(let userId):
            self.userId = userId
            validateLoginButtonState()

        case .passwordChanged(let password):
            self.password = password
            validateLoginButtonState()

        case .loginTapped:
            login()
        }
    }
    
    private func validateLoginButtonState() {
        let isValid = !userId.isEmpty && !password.isEmpty
        output.onNext(.isLoginEnabled(isValid))
    }

    private func login() {
        guard !userId.isEmpty, !password.isEmpty else {
            output.onNext(.validationError("Both fields are required"))
            return
        }

        guard userUseCase.checkIfUserExists(by: userId) else {
            output.onNext(.loginFailure("User does not exist"))
            return
        }

        guard let userCredentials = userUseCase.getUser(by: userId),
              userCredentials.passwordHash == password else {
            output.onNext(.loginFailure("Incorrect Password"))
            return
        }

        userUseCase.setLoggedInUser(userId: userId)
        output.onNext(.loginSuccess(userId))
    }

}


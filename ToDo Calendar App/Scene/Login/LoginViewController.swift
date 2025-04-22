//
//  LoginViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    protocol Delegate: AnyObject {
        func onLoginSuccess(userId: String)
        func showRegisterScreen(from: LoginViewController)
    }
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var userIdTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "User ID"
        textField.textContentType = .givenName
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = PasswordTextField()
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .done
        return textField
    }()

    private lazy var userIdView = TextFieldError(textField: userIdTextField)
    private lazy var passwordView = TextFieldError(textField: passwordTextField)
    
    private lazy var loginButton: SystemButton = {
        let button = SystemButton()
        button.kind = .main
        return button
    }()
    private lazy var registerButton: SystemButton = {
        let button = SystemButton()
        button.kind = .black
        return button
    }()
    
    weak var delegate: Delegate?

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        title = "Login"

        loginButton.setTitle("Login", for: .normal)
        registerButton.setTitle("Register", for: .normal)

        let stackView = UIStackView(arrangedSubviews: [userIdView, passwordView, loginButton, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        registerButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }

    private func setupBindings() {
        
        userIdTextField.rx.text.orEmpty
            .map { LoginViewModel.Input.userIdChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .map { LoginViewModel.Input.passwordChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .map { LoginViewModel.Input.loginTapped }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        viewModel.output
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .validationError(let errorMessage):
                    self?.userIdView.showError(errorMessage)
                    self?.passwordView.showError(errorMessage)
                case .loginSuccess(let userId):
                    self?.delegate?.onLoginSuccess(userId: userId)
                case .loginFailure(let errorMessage):
                    self?.userIdView.showError(errorMessage)
                    self?.passwordView.showError(errorMessage)
                case .isLoginEnabled(let isEnabled):
                    self?.loginButton.isEnabled = isEnabled
                }
            })
            .disposed(by: disposeBag)
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegisterButton() {
        self.delegate?.showRegisterScreen(from: self)
        
    }
}



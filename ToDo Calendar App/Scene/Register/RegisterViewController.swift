//
//  RegisterViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    private let viewModel: RegisterViewModel
    private let disposeBag = DisposeBag()

    private lazy var userIdTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "User ID"
        textField.textContentType = .username
        textField.returnKeyType = .next
        return textField
    }()
    private lazy var userIdView = TextFieldError(textField: userIdTextField)
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Full Name"
        textField.textContentType = .name
        textField.returnKeyType = .next
        return textField
    }()
    private lazy var nameView = TextFieldError(textField: nameTextField)
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = PasswordTextField()
        textField.placeholder = "Password"
        textField.textContentType = .newPassword
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .next
        return textField
    }()
    private lazy var passwordView = TextFieldError(textField: passwordTextField)
    
    private lazy var confirmPasswordTextField: CustomTextField = {
        let textField = PasswordTextField()
        textField.placeholder = "Confirm Password"
        textField.textContentType = .newPassword
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .next
        return textField
    }()
    private lazy var confirmPasswordView = TextFieldError(textField: confirmPasswordTextField)
    
    private lazy var registerButton: SystemButton = {
        let button = SystemButton()
        button.kind = .main
        button.isEnabled = false
        button.setTitle("Register", for: .normal)
        return button
    }()
    
    private lazy var goBackButton: SystemButton = {
        let button = SystemButton()
        button.kind = .black
        button.setTitle("Go back to login", for: .normal)
        return button
    }()

    init(viewModel: RegisterViewModel) {
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
        title = "Register"
        
        let stackView = UIStackView(arrangedSubviews: [userIdView, nameView, passwordView, confirmPasswordView, registerButton, goBackButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        registerButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        goBackButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }

    private func setupBindings() {
        
        userIdTextField.rx.text.orEmpty
            .map { RegisterViewModel.Input.userIdChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map { RegisterViewModel.Input.nameChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .map { RegisterViewModel.Input.passwordChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        confirmPasswordTextField.rx.text.orEmpty
            .map { RegisterViewModel.Input.confirmPasswordChanged($0) }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .map { RegisterViewModel.Input.registerTapped }
            .subscribe(onNext: { [weak self] input in
                self?.viewModel.transform(input: input)
            })
            .disposed(by: disposeBag)
        
        goBackButton.addTarget(self, action: #selector(didTapGoBackToLogin), for: .touchUpInside)

        viewModel.output
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .validationError(let error):
                    self?.userIdView.showError(error)
                    self?.nameView.showError(error)
                    self?.passwordView.showError(error)
                    self?.confirmPasswordView.showError(error)
                case .registerSuccess:
                    self?.showAlert(message: "Registration successful!")
                case .registerFailure(let error):
                    self?.userIdView.showError(error)
                case .isRegisterEnabled(let isEnabled):
                    self?.registerButton.isEnabled = isEnabled
                case .passwordValidationError(let error):
                    self?.passwordView.showError(error)
                    self?.confirmPasswordView.showError(error)
                case .passwordStrengthErrorMessage(let error):
                    self?.passwordView.showError(error)
                    self?.confirmPasswordView.showError(error)
                case .hidePasswordErrorMessage:
                    self?.passwordView.hideError()
                    self?.confirmPasswordView.hideError()
                case .nameValidationError(let error):
                    self?.nameView.showError(error)
                case .hideNameErrorMessage:
                    self?.nameView.hideError()
                }
            })
            .disposed(by: disposeBag)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.didTapGoBackToLogin()
        }))
        present(alert, animated: true)
    }
    
    @objc private func didTapGoBackToLogin() {
        self.dismiss(animated: true)
    }
}


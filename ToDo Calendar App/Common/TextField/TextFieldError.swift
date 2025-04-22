//
//  TextFieldError.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import SnapKit

private enum Constants {
    static let animationDuration: TimeInterval = 0.3
    static let labelErrorHeight: CGFloat = 26
}

public final class TextFieldError: UIView {

    private enum AccessibilityIDs: String {
        case validationErrorLabel
    }
    
    // MARK: - Properties
    private let labelError: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = .red
        label.accessibilityIdentifier = AccessibilityIDs.validationErrorLabel.rawValue
        return label
    }()

    private let viewLabel: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()
    private var errorHeightConstraint: Constraint?
    
    public let textField: CustomTextField
    public var onError: (() -> String?)?

    // MARK: - Initializators
    public init(textField: CustomTextField = CustomTextField()) {
        self.textField = textField
        super.init(frame: .zero)
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        viewLabel.addSubview(labelError)
        labelError.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(viewLabel)
        viewLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(textField.snp.bottom)
            self.errorHeightConstraint = make.height.equalTo(0).constraint
        }
        
        textField.onEditingBeging = { [weak self] in
            self?.hideError()
        }
        textField.onErrorChange = { [weak self] in
            guard let self = self else { return false }
            if let error = self.onError?() {
                self.labelError.text = error
                errorHeightConstraint?.update(offset: 0)
                UIView.animate(withDuration: Constants.animationDuration) {
                    self.viewLabel.alpha = 1
                    self.layoutIfNeeded()
                }
                return true
            } else {
                self.viewLabel.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                UIView.animate(withDuration: Constants.animationDuration) {
                    self.viewLabel.alpha = 0
                }
                
                return false
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(classForCoder, #function)
    }

    // MARK: - Lifecycle
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }

    @discardableResult
    override public func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - Internal methods
public extension TextFieldError {

    func showError(_ error: String) {
        labelError.text = error
        errorHeightConstraint?.update(offset: Constants.labelErrorHeight)
        viewLabel.isHidden = false
        UIView.animate(withDuration: Constants.animationDuration) {
            self.viewLabel.alpha = 1
            self.layoutIfNeeded()
        }
        textField.showErrorState()
    }
    
    func hideError() {
        if viewLabel.alpha == 0 {
            return
        }
        errorHeightConstraint?.update(offset: 0)
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.viewLabel.alpha = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            self.viewLabel.isHidden = true // 👈 Prevent re-showing immediately
        })
        textField.showActiveState()
    }
}

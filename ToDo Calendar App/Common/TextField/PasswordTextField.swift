//
//  PasswordTextField.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit

private enum Constants {
    static let animationDuration: TimeInterval = 0.3
}

public final class PasswordTextField: CustomTextField {
    
    // MARK: - Properties
    private let insets = UIEdgeInsets(top: 14.0, left: 16.0, bottom: 0, right: 16.0)
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.alpha = 0
        button.addTarget(self, action: #selector(changeSecurity), for: .touchUpInside)
        button.setImage(defaultImage, for: .normal)
        return button
    }()
    
    private var activeImage: UIImage {
        return #imageLiteral(resourceName: "passwordSecurityActive")
    }
    
    private var defaultImage: UIImage {
        return #imageLiteral(resourceName: "passwordSecurity")
    }
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        isSecureTextEntry = true
        self.addRightView()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided methods
    override public func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)

        UIView.animate(withDuration: Constants.animationDuration) {
            self.button.alpha = 1
        }
    }
    
    override public func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        
        UIView.animate(withDuration: Constants.animationDuration) {
            self.button.alpha = self.isSecureTextEntry ? 0 : 1
        }
    }
        
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return setInsets(forBounds: bounds)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = CGSize(width: 40.0, height: 50.0)
        return CGRect(x: bounds.width - size.width, y: 0, width: size.width, height: bounds.height)
    }
        
}

// MARK: - Private methods
private extension PasswordTextField {
    
    func addRightView() {
        self.rightViewMode = .always
        self.rightView = button
    }
    
    @objc
    func changeSecurity() {
        isSecureTextEntry.toggle()
        button.setImage(isSecureTextEntry ? defaultImage : activeImage, for: .normal)
    }
    
    func setInsets(forBounds bounds: CGRect) -> CGRect {
        var totalInsets = insets
        if let rightView = rightView {
            totalInsets.right = rightView.bounds.size.width
        } else {
            totalInsets.right = 0.0
        }
        return bounds.inset(by: totalInsets)
    }
}

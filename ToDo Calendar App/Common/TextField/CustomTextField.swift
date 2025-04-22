//
//  CustomTextField.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit

open class CustomTextField: UITextField {

    private enum Constants {
        static let leftPadding: CGFloat = 16
        static let height: CGFloat = 56
        static let topPadding: CGFloat = 14
        static let animationDuration: TimeInterval = 0.3
    }
    
    public enum LabelPosition {
        case top
        case center
    }
    
    public var textInputDisabled: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var alphaCompenent: CGFloat {
        return textInputDisabled ? 0.5 : 1
    }
    
    func updateUI() {
        labelPlaceholderAnimation.textColor = .gray.withAlphaComponent(alphaCompenent)
        labelPlaceholderMask.textColor = .gray.withAlphaComponent(alphaCompenent)
        textColor = .black.withAlphaComponent(alphaCompenent)
        backgroundColor = .clear
    }

    // MARK: - Properties
    private var position: LabelPosition = .center
    private weak var internalDelegate: UITextFieldDelegate?

    public var onErrorChange: (() -> Bool)?
    public var onEditingBeging: (() -> Void)?
    public var onShouldReturn: ((UITextField) -> Void)?

    private lazy var labelPlaceholderAnimation: UILabel = {
        let label = UILabel()
        label.font = placeholderFont
        label.textColor = .gray
        return label
    }()

    private lazy var labelPlaceholderMask: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = placeholderFont
        label.textColor = .gray
        return label
    }()

    public var placeholderFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            changeLabelPlaceholder(animation: false)
            labelPlaceholderMask.font = placeholderFont
        }
    }

    public var placeholderMask: String? {
        didSet {
            if let mask = placeholderMask {
                labelPlaceholderMask.text = mask
            } else {
                labelPlaceholderMask.text = labelPlaceholderAnimation.text
            }
            labelPlaceholderMask.sizeToFit()
        }
    }

    public var isEmptyText: Bool {
        return text?.isEmpty ?? true
    }

    override public weak var delegate: UITextFieldDelegate? {
        didSet {
            internalDelegate = delegate
            super.delegate = self
        }
    }
    
    override public var text: String? {
        didSet {
            super.text = text
            textDidChange()
            position = isEmptyText ? .center : .top
            changeLabelPlaceholder(animation: false)
        }
    }
    
    override public var placeholder: String? {
        didSet {
            labelPlaceholderAnimation.text = placeholder
            labelPlaceholderMask.text = placeholder
            labelPlaceholderAnimation.sizeToFit()
            labelPlaceholderMask.sizeToFit()
            super.placeholder = ""
        }
    }

    override public var intrinsicContentSize: CGSize {
        return .init(width: super.intrinsicContentSize.width, height: 56)
    }

    // MARK: - Initializators
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Lifecycle
    override open func layoutSubviews() {
        super.layoutSubviews()
        changeLabelPlaceholder(animation: false)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: Constants.leftPadding, y: Constants.topPadding, width: bounds.width - Constants.leftPadding * 2, height: bounds.size.height - Constants.topPadding)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, with: event)
        if textInputDisabled, v === self {
            return nil
        }
        return v
    }
}

// MARK: - Private methods
private extension CustomTextField {

    func setup() {
        super.delegate = self

        textColor = .black
        backgroundColor = .clear
        showDefaultState()
        self.layer.cornerRadius = 8
        autocorrectionType = .no
        leftView = UIView(frame: .init(x: 0, y: 0, width: Constants.leftPadding, height: 0))
        leftViewMode = .always

        addSubview(labelPlaceholderAnimation)
        labelPlaceholderAnimation.frame.origin.x = Constants.leftPadding
        
        addSubview(labelPlaceholderMask)
        labelPlaceholderMask.frame.origin.x = Constants.leftPadding
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func changeLabelPlaceholder(animation: Bool) {
        let font: UIFont
        let offset: CGFloat
        if position == .top {
            font = .systemFont(ofSize: 13)
            offset = 4
        } else {
            font = placeholderFont
            offset = (frame.size.height - labelPlaceholderAnimation.frame.size.height) / 2
        }

        if animation {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.labelPlaceholderMask.alpha = self.position == .top ? 1 : 0
            }

            UIView.transition(with: labelPlaceholderAnimation, duration: Constants.animationDuration, options: .transitionCrossDissolve, animations: {
                self.labelPlaceholderAnimation.font = font
                self.labelPlaceholderAnimation.frame.origin.y = offset
            })

        } else {
            self.labelPlaceholderAnimation.font = font
            self.labelPlaceholderAnimation.frame.origin.y = offset
            self.labelPlaceholderMask.alpha = position == .top ? 1 : 0
        }
        
        labelPlaceholderMask.frame.origin.y = (frame.size.height - labelPlaceholderMask.frame.size.height) / 2 + Constants.topPadding / 2
    }
    
    @objc
    func textDidChange() {
        labelPlaceholderMask.isHidden = !isEmptyText
    }
}

// MARK: - Internal methods
public extension CustomTextField {

    func showErrorState() {
        layer.borderColor = UIColor.red.withAlphaComponent(alphaCompenent).cgColor
        layer.borderWidth = 2
    }

    func showActiveState() {
        layer.borderColor = UIColor.darkGray.withAlphaComponent(alphaCompenent).cgColor
        layer.borderWidth = 2
    }

    func showDefaultState() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let delegate = internalDelegate,
           delegate.responds(to: #selector(textField(_:shouldChangeCharactersIn:replacementString:))) {
            return delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? false
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        showActiveState()
        position = .top
        changeLabelPlaceholder(animation: true)
        
        onEditingBeging?()
        
        internalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        showDefaultState()
        position = isEmptyText ? .center : .top
        changeLabelPlaceholder(animation: true)
        
        if !isEmptyText {
            if let error = onErrorChange?(), error == true {
                showErrorState()
            }
        }
        
        internalDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFieldShouldReturn = internalDelegate?.textFieldShouldReturn {
            return textFieldShouldReturn(textField)
        } else if let onShouldReturn = onShouldReturn {
            onShouldReturn(self)
        } else {
            self.endEditing(true)
        }
        return true
    }
}

//
//  CustomTextView.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/22/25.
//

import UIKit

public final class CustomTextView: UITextView {
    
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
    
    private var position: LabelPosition = .center
    private weak var internalDelegate: UITextViewDelegate?
    
    public var textInputDisabled: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var alphaCompenent: CGFloat {
        return textInputDisabled ? 0.5 : 1
    }
    
    
    func updateUI() {
        labelPlaceholder.textColor = .gray.withAlphaComponent(alphaCompenent)
        labelPlaceholderMask.textColor = .gray.withAlphaComponent(alphaCompenent)
        textColor = .black.withAlphaComponent(alphaCompenent)
        backgroundColor = .clear
    }
    
    // MARK: - Properties
    public let labelPlaceholder: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private let labelPlaceholderMask: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    public var placeholderFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            labelPlaceholderMask.font = placeholderFont
        }
    }
    
    public var placeholderMask: String? {
        didSet {
            if let mask = placeholderMask {
                labelPlaceholderMask.text = mask
            } else {
                labelPlaceholderMask.text = labelPlaceholder.text
            }
            labelPlaceholderMask.sizeToFit()
        }
    }
    
    public var isEmptyText: Bool {
        return text?.isEmpty ?? true
    }
    
    public var placeholder: String? {
        didSet {
            labelPlaceholder.text = placeholder
            labelPlaceholderMask.text = placeholder
            labelPlaceholder.sizeToFit()
            labelPlaceholderMask.sizeToFit()
            
            self.labelPlaceholder.text = ""
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return .init(width: super.intrinsicContentSize.width, height: 56)
    }

    // MARK: - Initializators
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Public methods
    public func showErrorState() {
        layer.borderColor = UIColor.red.withAlphaComponent(alphaCompenent).cgColor
        layer.borderWidth = 2
    }

    public func showActiveState() {
        layer.borderColor = UIColor.darkGray.withAlphaComponent(alphaCompenent).cgColor
        layer.borderWidth = 2
    }

    public func showDefaultState() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
    }

    // MARK: - Private methods
    private func setupUI() {
        layer.cornerRadius = 6
        showDefaultState()
        
        textContainerInset.left = 11
        textContainerInset.top = 24
        font = .systemFont(ofSize: 17)
        textColor = UIColor.black
        backgroundColor = .clear
        addSubview(labelPlaceholder)
        labelPlaceholder.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(24)
            make.width.equalToSuperview().inset(16)
        }
        
        addSubview(labelPlaceholderMask)
        labelPlaceholderMask.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(7)
        }
        textStorage.delegate = self
    }

}

// MARK: - NSTextStorageDelegate
extension CustomTextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        labelPlaceholder.isHidden = !textStorage.string.isEmpty
    }
}


//
//  SystemButton.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit

public class SystemButton: UIButton {

    public enum Kind {
        case main
        case black
    }

    // MARK: - Properties
    override public var isEnabled: Bool {
        didSet {
            updateToEnabledState()
        }
    }

    // MARK: - Properties
    private var buttonTitle: String?

    public var kind: Kind = .main {
        didSet {
            setupUI()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return .init(width: super.intrinsicContentSize.width, height: 48)
    }

    // MARK: - Initializators
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupButton()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupButton()
    }

    // MARK: - Public methods
    public func setTitle(_ title: String?,
                         for state: UIControl.State,
                         font: UIFont) {
        super.setTitle(title, for: state)
        if buttonTitle != title, title?.isEmpty == false {
            buttonTitle = title
        }
        titleLabel?.font = font
    }
    
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        self.setTitle(title, for: state, font: .systemFont(ofSize: 17, weight: .medium))
    }
    
    public func showAnimation() {
        isUserInteractionEnabled = false
        setTitle("", for: .normal)
    }
    
    public func hideAnimation() {
        isUserInteractionEnabled = true
        setTitle(buttonTitle, for: .normal)
    }
}

// MARK: - Private methods
private extension SystemButton {

    func setupButton() {
        layer.cornerRadius = 6
        layer.borderWidth = 1.0
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    }

    func setupUI() {
        updateToEnabledState()
    }

    func updateToEnabledState() {
        isUserInteractionEnabled = isEnabled
        if isEnabled {
            layer.borderColor = kind.activeBorderColor.cgColor
            tintColor = kind.activeTintColor
            backgroundColor = kind.activeBackgroundColor
            setTitleColor(kind.activeTintColor, for: .normal)
        } else {
            layer.borderColor = kind.inActiveBorderColor.cgColor
            tintColor = kind.inActiveTintColor
            backgroundColor = kind.inActiveBackgroundColor
            setTitleColor(kind.inActiveTintColor, for: .normal)
        }
    }
}

// MARK: - Kind + Variables
extension SystemButton.Kind {

    var activeBackgroundColor: UIColor {
        switch self {
        case .black:
            return .black
        case .main:
            return .blue
        }
    }

    var inActiveBackgroundColor: UIColor {
        switch self {
        case .main, .black:
            return activeBackgroundColor.withAlphaComponent(0.4)
        }
    }

    var activeTintColor: UIColor {
        switch self {
        case .main,.black:
            return .white
        }
    }

    var inActiveTintColor: UIColor {
        switch self {
        case .black, .main:
            return activeTintColor
        }
    }

    var activeBorderColor: UIColor {
        switch self {
        case .main:
            return .clear
        case .black:
            return .darkGray
        }
    }

    var inActiveBorderColor: UIColor {
        switch self {
        case .main, .black:
            return activeBorderColor
        }
    }
}

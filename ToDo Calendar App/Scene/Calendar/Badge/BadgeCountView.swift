//
//  BadgeCountView.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/22/25.
//

import UIKit

class BadgeCountView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 8, height: 8)
    }
    
    init(color: UIColor, size: CGFloat) {
        super.init(frame: .zero)
        backgroundColor = color
        layer.cornerRadius = size / 2
        clipsToBounds = true
        
        self.snp.makeConstraints { make in
            make.size.equalTo(size)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

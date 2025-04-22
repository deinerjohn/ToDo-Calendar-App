//
//  ToDoDateCell.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/22/25.
//

import UIKit
import domain

class ToDoDateCell: UITableViewCell {
    
    static let reuseIdentifier = "ToDoDateCellID"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let priorityImageView: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemRed
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        verticalStack.axis = .vertical
        verticalStack.spacing = 4

        let container = UIStackView(arrangedSubviews: [verticalStack, priorityImageView])
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center

        contentView.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
        
        priorityImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
    }

    func configure(with item: ToDoItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = formatter.date(from: item.startDate) {
            formatter.dateFormat = "HH:mm"
        } else {
        }
        
        
        let exclamationIcon: String
        switch item.priority {
        case .high: exclamationIcon = "exclamationmark.3"
        case .medium: exclamationIcon = "exclamationmark.2"
        case .low: exclamationIcon = "exclamationmark"
        }
        
        priorityImageView.image = UIImage(systemName: exclamationIcon)
    }
}

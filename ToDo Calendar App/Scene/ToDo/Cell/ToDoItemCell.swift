//
//  ToDoItemCell.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import domain

class ToDoItemCell: UITableViewCell {
    
    static let reuseIdentifier = "ToDoItemCellID"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let statusLabel: PaddingLabel = {
        let label = PaddingLabel()
        
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
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
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        [titleLabel, startDateLabel, statusLabel, priorityImageView].forEach {
            contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(statusLabel.snp.leading).offset(-8)
        }

        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(12)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }

        priorityImageView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(16)
        }
    }

    func configure(with item: ToDoItem) {
        titleLabel.text = item.title
        startDateLabel.text = item.startDate
        statusLabel.text = item.setTodoStatus.valueText
        
        

        switch item.setTodoStatus {
        case .notStarted:
            statusLabel.backgroundColor = .lightGray
        case .inProgress:
            statusLabel.backgroundColor = .systemBlue
        case .done:
            statusLabel.backgroundColor = .systemGreen
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

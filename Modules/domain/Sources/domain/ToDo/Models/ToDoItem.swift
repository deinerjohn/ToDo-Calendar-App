//
//  ToDoItem.swift
//  domain
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation

public enum ToDoPriority: String, Codable, CaseIterable {
    case low, medium, high
    
    public var valueText: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

public enum ToDoStatus: String, Codable, CaseIterable {
    case notStarted
    case inProgress
    case done
    
    public var valueText: String {
        switch self {
        case .notStarted:
            return "Not yet started"
        case .inProgress:
            return "In Progress"
        case .done:
            return "Done"
        }
    }
}

public struct ToDoItem: Codable, Equatable {
    
    public let id: String
    public let title: String
    public let description: String
    public let startDate: String
    public let endDate: String
    public let userId: String
    public var priority: ToDoPriority
    
    public init(id: String, title: String, description: String, startDate: String, endDate: String, userId: String, priority: ToDoPriority) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.userId = userId
        self.priority = priority
    }
    
    public var setTodoStatus: ToDoStatus {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            return .notStarted
        }

        let now = Date()

        if now < start {
            return .notStarted
        } else if now >= start && now <= end {
            return .inProgress
        } else {
            return .done
        }
    }
    
}

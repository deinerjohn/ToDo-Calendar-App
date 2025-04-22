//
//  Extensions++.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/22/25.
//
import Foundation
import domain
import UIKit

extension ToDoItem {

    var dateRangeComponents: [DateComponents] {
        guard let start = startDate.toDate(), let end = endDate.toDate() else { return [] }
        return Date.dates(from: start, to: end).map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }
    }
}

extension String {
    
    var isPasswordStrong: Bool {
        let pattern = "^(?=.*[A-Z])(?=.*[0-9]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    var isValidName: Bool {
        let pattern = "^[A-Za-z ]+$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func toDate(format: String = "yyyy-MM-dd HH:mm") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.date(from: self)
    }
    
}

extension Date {
    static func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate

        let calendar = Calendar.current
        while currentDate <= endDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }

        return dates
    }
    
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
}

extension Notification.Name {
    static let didRequestLogout = Notification.Name("didRequestLogout")
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

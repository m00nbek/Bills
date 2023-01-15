//
//  Date+TestHelpers.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import Foundation

extension Date {
    func formatted() -> String {
        let days = days(self)
        switch days {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return "\(days) days ago"
        }
    }
    
    private func days(_ start: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: Date()).day!
    }
}

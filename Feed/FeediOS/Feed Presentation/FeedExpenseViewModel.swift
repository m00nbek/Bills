//
//  FeedExpenseViewModel.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import Foundation
import UIKit
import Feed

final class FeedExpenseViewModel {
    private let model: FeedExpense
    
    init(model: FeedExpense) {
        self.model = model
    }
    
    var expenseTitle: String? {
        return model.title
    }
    
    var cost: String?  {
        return "\(model.cost)"
    }
    
    var date: String? {
        return FeedExpenseDateFormatter.string(for: model.timestamp)
    }
}

fileprivate class FeedExpenseDateFormatter {
    static func string(for date: Date) -> String {
        let days = days(date)
        switch days {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return "\(days) days ago"
        }
    }
    
    private static func days(_ start: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: Date()).day!
    }
}

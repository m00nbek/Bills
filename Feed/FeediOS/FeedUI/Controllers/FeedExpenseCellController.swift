//
//  FeedExpenseCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import Feed

final class FeedExpenseCellController {
    private let model: FeedExpense
    
    init(model: FeedExpense) {
        self.model = model
    }
    
    func view() -> UITableViewCell {
        let cell = FeedExpenseCell()
        cell.expenseTitleLabel.text = model.title
        cell.costLabel.text = "\(model.cost)"
        cell.dateLabel.text = model.timestamp.formatted()
        return cell
    }
}

private extension Date {
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

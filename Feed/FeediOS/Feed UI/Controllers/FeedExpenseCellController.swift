//
//  FeedExpenseCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import Feed

final class FeedExpenseCellController {
    private let viewModel: FeedExpenseViewModel
    
    init(viewModel: FeedExpenseViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(FeedExpenseCell())
        return cell
    }
    
    private func binded(_ cell: FeedExpenseCell) -> FeedExpenseCell {
        cell.expenseTitleLabel.text = viewModel.expenseTitle
        cell.costLabel.text = viewModel.cost
        cell.dateLabel.text = viewModel.date
        return cell
    }
}

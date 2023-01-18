//
//  FeedExpenseCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import Feed

public final class FeedExpenseCellController {
    private let viewModel: FeedExpenseViewModel
    
    public init(viewModel: FeedExpenseViewModel) {
        self.viewModel = viewModel
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: FeedExpenseCell = tableView.dequeueReusableCell()
        setup(cell)
        return cell
    }
    
    private func setup(_ cell: FeedExpenseCell) {
        cell.expenseTitleLabel.text = viewModel.expenseTitle
        cell.costLabel.text = viewModel.cost
        cell.dateLabel.text = viewModel.date
    }
}

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
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedExpenseCell") as! FeedExpenseCell
        setup(cell)
        return cell
    }
    
    private func setup(_ cell: FeedExpenseCell) {
        cell.expenseTitleLabel.text = viewModel.expenseTitle
        cell.costLabel.text = viewModel.cost
        cell.dateLabel.text = viewModel.date
    }
}

//
//  FeedExpenseCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import Feed

public final class FeedExpenseCellController: NSObject {
    private let viewModel: FeedExpenseViewModel
    
    public init(viewModel: FeedExpenseViewModel) {
        self.viewModel = viewModel
    }
}

extension FeedExpenseCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedExpenseCell = tableView.dequeueReusableCell()
        cell.expenseTitleLabel.text = viewModel.expenseTitle
        cell.costLabel.text = viewModel.cost
        cell.dateLabel.text = viewModel.date
        return cell
    }
}

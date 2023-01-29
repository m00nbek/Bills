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
    private let selection: () -> Void
    private var cell: FeedExpenseCell?
    
    public init(viewModel: FeedExpenseViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }
}

extension FeedExpenseCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.expenseTitleLabel.text = viewModel.expenseTitle
        cell?.costLabel.text = viewModel.cost
        cell?.dateLabel.text = viewModel.date
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection()
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

//
//  FeedViewController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import UIKit
import Feed

final public class FeedViewController: UITableViewController {
    private var refreshController: FeedRefreshViewController?
    private var tableModel = [FeedExpense]() {
        didSet { tableView.reloadData() }
    }
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.refreshController = FeedRefreshViewController(feedLoader: loader)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedExpenseCell()
        cell.expenseTitleLabel.text = cellModel.title
        cell.costLabel.text = "\(cellModel.cost)"
        cell.dateLabel.text = cellModel.timestamp.formatted()
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

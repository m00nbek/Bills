//
//  FeedViewController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import UIKit
import Feed

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var tableModel = [FeedExpense]()
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.tableModel = feed
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            case .failure:
                break
            }
            
        }
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

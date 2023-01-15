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
    private var cellControllers = [IndexPath: FeedExpenseCellController]()
    
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
        cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedExpenseCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedExpenseCellController(model: cellModel)
        cellControllers[indexPath] = cellController
        return cellController
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}

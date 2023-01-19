//
//  FeedViewController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import UIKit
import Feed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, FeedLoadingView, FeedErrorView {
    @IBOutlet private(set) public var errorView: ErrorView?
    
    private var tableModel = [FeedExpenseCellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var delegate: FeedViewControllerDelegate?
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    public func display(_ cellControllers: [FeedExpenseCellController]) {
        tableModel = cellControllers
    }
    
    public func display(_ viewModel: FeedLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedExpenseCellController {
        return tableModel[indexPath.row]
    }
}

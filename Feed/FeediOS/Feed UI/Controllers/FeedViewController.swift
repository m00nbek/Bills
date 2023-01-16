//
//  FeedViewController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import UIKit

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, FeedLoadingView {
    var delegate: FeedViewControllerDelegate?
    
    var tableModel = [FeedExpenseCellController]() {
        didSet {
            if Thread.isMainThread {
                tableView.reloadData()
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.display(viewModel) }
        }

        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
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
